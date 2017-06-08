class HadoopNative < Formula
  desc "Hadoop with native libraries"
  homepage "https://hadoop.apache.org/"
  url "https://www.apache.org/dyn/closer.cgi?path=hadoop/common/hadoop-2.7.3/hadoop-2.7.3-src.tar.gz"
  mirror "https://archive.apache.org/dist/hadoop/common/hadoop-2.7.3/hadoop-2.7.3-src.tar.gz"
  sha256 "227785dc6e3e6ef8cfd64393b305d09078a209703c9c01910a1bddcf86be3054"

  depends_on :java => "1.7+"
  depends_on "cmake" => :build
  depends_on "maven" => :build
  depends_on "openssl"
  depends_on "protobuf250"
  depends_on "snappy"

  conflicts_with "hadoop", :because => "hadoop-native ships hadoop"

  patch :DATA

  def install
    system "mvn", "package", "-Pdist,native", "-DskipTests", "-Dtar", "-Dmaven.javadoc.skip=true"

    Dir.chdir "hadoop-dist/target/hadoop-2.7.3"

    rm_f Dir["bin/*.cmd", "sbin/*.cmd", "libexec/*.cmd", "etc/hadoop/*.cmd"]
    libexec.install %w[bin sbin lib libexec share etc]

    extra_java_env = {
      "JAVA_LIBRARY_PATH" => "${JAVA_LIBRARY_PATH}:/usr/local/opt/openssl/lib",
    }

    (libexec/"bin").children.each do |script|
      (bin/script.basename).write_env_script script, extra_java_env
    end

    (libexec/"sbin").children.each do |script|
      (sbin/script.basename).write_env_script script, extra_java_env
    end

    # But don't make rcc visible, it conflicts with Qt
    (bin/"rcc").unlink

    inreplace "#{libexec}/etc/hadoop/hadoop-env.sh",
      "export JAVA_HOME=${JAVA_HOME}",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    inreplace "#{libexec}/etc/hadoop/yarn-env.sh",
      "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
    inreplace "#{libexec}/etc/hadoop/mapred-env.sh",
      "# export JAVA_HOME=/home/y/libexec/jdk1.6.0/",
      "export JAVA_HOME=\"$(/usr/libexec/java_home)\""
  end

  def caveats; <<-EOS.undent
    In Hadoop's config file:
      #{libexec}/etc/hadoop/hadoop-env.sh,
      #{libexec}/etc/hadoop/mapred-env.sh and
      #{libexec}/etc/hadoop/yarn-env.sh
    $JAVA_HOME has been set to be the output of:
      /usr/libexec/java_home

    In the scripts under #{bin} and #{sbin},
    $JAVA_LIBRARY_PATH will be appended with:
      /usr/local/opt/openssl/lib
    EOS
  end

  test do
    output = shell_output("#{bin}/hadoop checknative")

    assert_match /hadoop:\s*true/, output
    assert_match /zlib:\s+true/, output
    assert_match /snappy:\s+true/, output
    assert_match /lz4:\s+true/, output
    assert_match /bzip2:\s+true/, output
    assert_match /openssl:\s+true/, output
  end
end

__END__
diff --git a/hadoop-common-project/hadoop-common/src/CMakeLists.txt b/hadoop-common-project/hadoop-common/src/CMakeLists.txt
index 942b19c..8b34881 100644
--- a/hadoop-common-project/hadoop-common/src/CMakeLists.txt
+++ b/hadoop-common-project/hadoop-common/src/CMakeLists.txt
@@ -16,6 +16,8 @@
 # limitations under the License.
 #

+SET(CUSTOM_OPENSSL_PREFIX /usr/local/opt/openssl)
+
 cmake_minimum_required(VERSION 2.6 FATAL_ERROR)

 # Default to release builds
@@ -116,8 +118,8 @@ set(T main/native/src/test/org/apache/hadoop)
 GET_FILENAME_COMPONENT(HADOOP_ZLIB_LIBRARY ${ZLIB_LIBRARIES} NAME)

 SET(STORED_CMAKE_FIND_LIBRARY_SUFFIXES ${CMAKE_FIND_LIBRARY_SUFFIXES})
-set_find_shared_library_version("1")
-find_package(BZip2 QUIET)
+set_find_shared_library_version("1.0")
+find_package(BZip2 REQUIRED)
 if (BZIP2_INCLUDE_DIR AND BZIP2_LIBRARIES)
     GET_FILENAME_COMPONENT(HADOOP_BZIP2_LIBRARY ${BZIP2_LIBRARIES} NAME)
     set(BZIP2_SOURCE_FILES
diff --git a/hadoop-common-project/hadoop-common/src/main/conf/core-site.xml b/hadoop-common-project/hadoop-common/src/main/conf/core-site.xml
index d2ddf89..ac8e351 100644
--- a/hadoop-common-project/hadoop-common/src/main/conf/core-site.xml
+++ b/hadoop-common-project/hadoop-common/src/main/conf/core-site.xml
@@ -17,4 +17,8 @@
 <!-- Put site-specific property overrides in this file. -->

 <configuration>
+<property>
+<name>io.compression.codec.bzip2.library</name>
+<value>libbz2.dylib</value>
+</property>
 </configuration>
diff --git a/hadoop-tools/hadoop-pipes/pom.xml b/hadoop-tools/hadoop-pipes/pom.xml
index 34c0110..70f23a4 100644
--- a/hadoop-tools/hadoop-pipes/pom.xml
+++ b/hadoop-tools/hadoop-pipes/pom.xml
@@ -52,7 +52,7 @@
                     <mkdir dir="${project.build.directory}/native"/>
                     <exec executable="cmake" dir="${project.build.directory}/native" 
                         failonerror="true">
-                      <arg line="${basedir}/src/ -DJVM_ARCH_DATA_MODEL=${sun.arch.data.model}"/>
+                      <arg line="${basedir}/src/ -DJVM_ARCH_DATA_MODEL=${sun.arch.data.model} -DOPENSSL_ROOT_DIR=/usr/local/opt/openssl"/>
                     </exec>
                     <exec executable="make" dir="${project.build.directory}/native" failonerror="true">
                       <arg line="VERBOSE=1"/>
