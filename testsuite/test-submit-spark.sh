#!/bin/bash

source test-common.sh

SubmitSparkStandardTests_BasicTests() {
    sparkversion=$1
    localdirtests=$2

    BasicJobSubmit magpie.${submissiontype}-spark-${sparkversion}-run-sparkpi

    if [ "${localdirtests}" == "y" ]
    then
	BasicJobSubmit magpie.${submissiontype}-spark-${sparkversion}-run-sparkpi-no-local-dir
    fi
}

SubmitSparkStandardTests_WordCount() {
    sparkversion=$1
    hadoopversion=$2
    localdirtests=$3

    BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsoverlustre-run-sparkwordcount-copy-in
    BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-sparkwordcount-copy-in
    BasicJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-spark-${sparkversion}-run-sparkwordcount-copy-in
    BasicJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-spark-${sparkversion}-run-pythonsparkwordcount

    if [ "${localdirtests}" == "y" ]
    then
	BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsoverlustre-run-sparkwordcount-copy-in-no-local-dir
	BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-sparkwordcount-copy-in-no-local-dir
	BasicJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-spark-${sparkversion}-run-sparkwordcount-copy-in-no-local-dir
	BasicJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-spark-${sparkversion}-run-pythonsparkwordcount-copy-in-no-local-dir
    fi
}

SubmitSparkStandardTests_YarnTests() {
    sparkversion=$1
    hadoopversion=$2
    
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsoverlustre-run-sparkpi
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsoverlustre-run-sparkpi-no-local-dir

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-sparkpi
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-sparkpi-no-local-dir
}

SubmitSparkStandardTests_YarnWordCount() {
    sparkversion=$1
    hadoopversion=$2

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsoverlustre-run-sparkwordcount-copy-in
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-sparkwordcount-copy-in
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-spark-${sparkversion}-hadoop-${hadoopversion}-run-sparkwordcount-copy-in
 
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsoverlustre-run-sparkwordcount-copy-in-no-local-dir
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-spark-${sparkversion}-hadoop-${hadoopversion}-hdfsovernetworkfs-run-sparkwordcount-copy-in-no-local-dir
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-spark-${sparkversion}-hadoop-${hadoopversion}-run-sparkwordcount-copy-in-no-local-dir
}

SubmitSparkStandardTests() {
    for testfunction in SubmitSparkStandardTests_BasicTests
    do
	for sparkversion in ${spark0Xjava16hadoop2versions}
	do
	    ${testfunction} ${sparkversion} "n"
	done
    
	for sparkversion in ${spark1Xjava16hadoop24versions}
	do
	    ${testfunction} ${sparkversion} "y"
	done
    
	for sparkversion in ${spark1Xjava17hadoop26versions}
	do
	    ${testfunction} ${sparkversion} "y"
	done
    done

    for testfunction in SubmitSparkStandardTests_WordCount
    do
	for sparkversion in ${spark0Xjava16hadoop2versions}
	do
	    for hadoopversion in ${spark0Xjava16hadoop2versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion} "n"
	    done
	done
	
	for sparkversion in ${spark1Xjava16hadoop24versions}
	do
	    for hadoopversion in ${spark1Xjava16hadoop24versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion} "y"
	    done
	done
	
	for sparkversion in ${spark1Xjava17hadoop26versions}
	do
	    for hadoopversion in ${spark1Xjava17hadoop26versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion} "y"
	    done
	done
    done

    for testfunction in SubmitSparkStandardTests_YarnTests SubmitSparkStandardTests_YarnWordCount
    do
	for sparkversion in ${spark1Xjava16hadoop24versions}
	do
	    for hadoopversion in ${spark1Xjava16hadoop24versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion}
	    done
	done

	for sparkversion in ${spark1Xjava17hadoop26versions}
	do
	    for hadoopversion in ${spark1Xjava17hadoop26versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion}
	    done
	done
    done
}

SubmitSparkDependencyTests_Dependency1HDFS() {
    sparkversion=$1
    hadoopversion=$2
    decommission=$3

    BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsoverlustre-expected-failure
    if [ "${decommission}" == "y" ]
    then
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-decommissionhdfsnodes
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-no-copy
    fi

    BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsovernetworkfs-expected-failure
    if [ "${decommission}" == "y" ]
    then
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-decommissionhdfsnodes
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark1A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-no-copy
    fi
}

SubmitSparkDependencyTests_Dependency2HDFS() {
    sparkversion=$1
    hadoopversion=$2
    decommission=$3
    
    BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsoverlustre-expected-failure
    if [ "${decommission}" == "y" ]
    then
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-decommissionhdfsnodes
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-no-copy
    fi

    BasicJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsovernetworkfs-expected-failure
    if [ "${decommission}" == "y" ]
    then
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-decommissionhdfsnodes
	DependentJobSubmit magpie.${submissiontype}-spark-with-hdfs-DependencySpark2A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-no-copy
    fi
}

SubmitSparkDependencyTests_Dependency3YarnHDFS() {
    sparkversion=$1
    hadoopversion=$2

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsoverlustre-expected-failure
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-decommissionhdfsnodes

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsovernetworkfs-expected-failure
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark3A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-decommissionhdfsnodes
}

SubmitSparkDependencyTests_Dependency4YarnHDFS() {
    sparkversion=$1
    hadoopversion=$2
    
    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsoverlustre-expected-failure
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsoverlustre-decommissionhdfsnodes
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsoverlustre-run-sparkwordcount-no-copy

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-fewer-nodes-hdfsovernetworkfs-expected-failure
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfs-more-nodes-hdfsovernetworkfs-decommissionhdfsnodes
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-hdfs-DependencySpark4A-hadoop-${hadoopversion}-spark-${sparkversion}-hdfsovernetworkfs-run-sparkwordcount-no-copy
}

SubmitSparkDependencyTests_Dependency5rawnetworkfs() {
    sparkversion=$1

    BasicJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark5A-spark-${sparkversion}-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark5A-spark-${sparkversion}-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark5A-spark-${sparkversion}-rawnetworkfs-more-nodes-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark5A-spark-${sparkversion}-run-sparkwordcount-no-copy
}

SubmitSparkDependencyTests_Dependency6rawnetworkfs() {
    sparkversion=$1

    BasicJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark6A-spark-${sparkversion}-rawnetworkfs-more-nodes-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark6A-spark-${sparkversion}-rawnetworkfs-more-nodes-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-rawnetworkfs-DependencySpark6A-spark-${sparkversion}-run-sparkwordcount-no-copy
}

SubmitSparkDependencyTests_Dependency7Yarnrawnetworkfs() {
    sparkversion=$1
    hadoopversion=$2

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark7A-spark-${sparkversion}-hadoop-${hadoopversion}-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark7A-spark-${sparkversion}-hadoop-${hadoopversion}-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark7A-spark-${sparkversion}-hadoop-${hadoopversion}-rawnetworkfs-more-nodes-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark7A-spark-${sparkversion}-hadoop-${hadoopversion}-run-sparkwordcount-no-copy
}

SubmitSparkDependencyTests_Dependency8Yarnrawnetworkfs() {
    sparkversion=$1
    hadoopversion=$2

    BasicJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark8A-spark-${sparkversion}-hadoop-${hadoopversion}-rawnetworkfs-more-nodes-run-sparkwordcount-copy-in
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark8A-spark-${sparkversion}-hadoop-${hadoopversion}-rawnetworkfs-more-nodes-run-sparkwordcount-no-copy
    DependentJobSubmit magpie.${submissiontype}-spark-with-yarn-and-rawnetworkfs-DependencySpark8A-spark-${sparkversion}-hadoop-${hadoopversion}-run-sparkwordcount-no-copy
}

SubmitSparkDependencyTests() {
    for testfunction in SubmitSparkDependencyTests_Dependency1HDFS SubmitSparkDependencyTests_Dependency2HDFS SubmitSparkDependencyTests_Dependency3YarnHDFS SubmitSparkDependencyTests_Dependency4YarnHDFS
    do
	for sparkversion in ${spark0Xjava16hadoop2versions}
	do
	    for hadoopversion in ${spark0Xjava16hadoop2versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion} "n"
	    done
	done

	for sparkversion in ${spark1Xjava16hadoop24versions}
	do
	    for hadoopversion in ${spark1Xjava16hadoop24versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion} "y"
	    done
	done

	for sparkversion in ${spark1Xjava17hadoop26versions}
	do
	    for hadoopversion in ${spark1Xjava17hadoop26versions_hadoopversion}
	    do
		${testfunction} ${sparkversion} ${hadoopversion} "y"
	    done
	done
    done

    for testfunction in SubmitSparkDependencyTests_Dependency5rawnetworkfs SubmitSparkDependencyTests_Dependency6rawnetworkfs SubmitSparkDependencyTests_Dependency7Yarnrawnetworkfs SubmitSparkDependencyTests_Dependency8Yarnrawnetworkfs
    do
	for sparkversion in ${spark0Xjava16hadoop2versions} ${spark1Xjava16hadoop24versions}
	do
	    ${testfunction} ${sparkversion}
	done
	
	for sparkversion in ${spark1Xjava17hadoop26versions}
	do
	    ${testfunction} ${sparkversion}
	done
    done
}
