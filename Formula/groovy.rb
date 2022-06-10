class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.3.zip"
  sha256 "ddfc8e26fdcf3626d1c83f28d198c3e4e616a72337ca6e46fcaca09e7a4bb37f"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3708bcafe903eeb2eac591c7eadb2386de9f96c7d81ff7c527fa29d46b703c28"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a10be4f13635f7ab7bad131f1ef08183e80ae18491649b86448160d3a6b6bc06"
    sha256 cellar: :any_skip_relocation, monterey:       "7be116fd5be2d69d5339872ba50545807a81ec5cf8a8980fc5d6bd66ca172b8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d4a1b8301373044c3f0e021c9a05059edd22963035164fc51d202239d951c36"
    sha256 cellar: :any_skip_relocation, catalina:       "6b1a0752d0f6311395605004663ef3e48aedf4404715aee6668d87b5e5d91e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb205fc2adc36491adb129415d84de37b7f9169e1da16709838c48a3625b2ffe"
  end

  depends_on "openjdk"

  on_macos do
    # Temporary build dependencies for compiling jansi-native
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "maven" => :build

    # jansi-native is used to build native binary to support Apple Silicon.
    # Source version is from jline-2.14.6 -> jansi-1.12 -> jansi-native-1.6
    # TODO: Remove once updated to jline-3.x: https://issues.apache.org/jira/browse/GROOVY-8162
    resource "jansi-native" do
      url "https://github.com/fusesource/jansi-native/archive/refs/tags/jansi-native-1.6.tar.gz"
      sha256 "f4075ad012c9ed79eaa8d3240d869e10d94ca8b130f3e7dac2ba3978dce0fb21"

      # Update pom.xml to replace unsupported Java 6 source and to disable universal binary
      patch :DATA
    end
  end

  conflicts_with "groovysdk", because: "both install the same binaries"

  def install
    if OS.mac?
      jline_jar = buildpath/"lib/jline-2.14.6.jar"
      resource("jansi-native").stage do
        system "mvn", "-Dplatform=osx", "prepare-package"
        system "zip", "-d", jline_jar, "META-INF/native/*"
        system "jar", "-uvf", jline_jar,
                      "-C", "target/generated-sources/hawtjni/lib",
                      "META-INF/native/osx64/libjansi.jnilib"
      end
    end

    # Don't need Windows files.
    rm_f Dir["bin/*.bat"]

    libexec.install "bin", "conf", "lib"
    bin.install Dir["#{libexec}/bin/*"] - ["#{libexec}/bin/groovy.ico"]
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

  def caveats
    <<~EOS
      You should set GROOVY_HOME:
        export GROOVY_HOME=#{opt_libexec}
    EOS
  end

  test do
    output = shell_output("#{bin}/grape install org.activiti activiti-engine 5.16.4")
    assert_match "found org.activiti#activiti-engine;5.16.4", output
    assert_match "65536\n===> null\n", pipe_output("#{bin}/groovysh", "println 64*1024\n:exit\n")
  end
end

__END__
diff --git a/pom.xml b/pom.xml
index 369cc8c..6dbac6f 100644
--- a/pom.xml
+++ b/pom.xml
@@ -151,8 +151,8 @@
         <groupId>org.apache.maven.plugins</groupId>
         <artifactId>maven-compiler-plugin</artifactId>
         <configuration>
-          <source>1.5</source>
-          <target>1.5</target>
+          <source>1.7</source>
+          <target>1.7</target>
         </configuration>
       </plugin>
       
@@ -306,35 +306,5 @@
       </build>
     </profile>
     
-
-    <!-- Profile which enables Universal binaries on OS X -->
-    <profile>
-      <id>mac</id>
-      <activation>
-        <os><family>mac</family></os>
-      </activation>
-      <build>
-        <plugins>
-          <plugin>
-            <groupId>org.fusesource.hawtjni</groupId>
-            <artifactId>maven-hawtjni-plugin</artifactId>
-            <configuration>
-              <osgiPlatforms>
-                <osgiPlatform>osname=MacOS;processor=x86-64</osgiPlatform>
-                <osgiPlatform>osname=MacOS;processor=x86</osgiPlatform>
-                <osgiPlatform>osname=MacOS;processor=PowerPC</osgiPlatform>
-                <osgiPlatform>*</osgiPlatform>
-              </osgiPlatforms>
-              <configureArgs>
-                <arg>--with-universal</arg>
-              </configureArgs>
-              <platform>osx</platform>
-            </configuration>
-          </plugin>
-        </plugins>
-      </build>
-    </profile>
-    
-    
   </profiles>
 </project>
