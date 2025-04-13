class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.26.zip"
  sha256 "3be6880c6de70eada2f3f5c69e1e94953e0b0c4e33c4604c1040d05dddeaed92"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "01d38cc4506d01f19e7929cf2e6439f0172f201295c29ffbfbe318b762ca0873"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "396cb169e74ebaa376cdc543a6f6d003762f7f69e6c915cd76193d948ff6b5db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "523ef0ebea47675193f16febf9746d6970c7d281d8a55e9a3a73b3fb642f2aac"
    sha256 cellar: :any_skip_relocation, sonoma:        "6c518e8769da4424ea82c9dd6bd607eea29ae05bbc3db913dfb38365323f0e4a"
    sha256 cellar: :any_skip_relocation, ventura:       "13fa23cb52ea09231099da62761ec2d29003a438232daf126c7e57c8d3842b3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "787e84253dd6041a7448346bc09b99d6642523b2f10bb955a4cd5f4acf3013eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "787e84253dd6041a7448346bc09b99d6642523b2f10bb955a4cd5f4acf3013eb"
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
        # Fix compile with newer Clang
        ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

        system "mvn", "-Dplatform=osx", "prepare-package"
        system "zip", "-d", jline_jar, "META-INF/native/*"
        system "jar", "-uvf", jline_jar,
                      "-C", "target/generated-sources/hawtjni/lib",
                      "META-INF/native/osx64/libjansi.jnilib"
      end
    end

    # Don't need Windows files.
    rm(Dir["bin/*.bat"])

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
+          <source>1.8</source>
+          <target>1.8</target>
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
