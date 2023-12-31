class Groovy < Formula
  desc "Java-based scripting language"
  homepage "https://www.groovy-lang.org/"
  url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/apache-groovy-binary-4.0.17.zip"
  sha256 "05d8fc8f3c3c583850fc7f46c235ca4c8b58024ec8d9d7c16f72548a2b2b5430"
  license "Apache-2.0"

  livecheck do
    url "https://groovy.jfrog.io/artifactory/dist-release-local/groovy-zips/"
    regex(/href=.*?apache-groovy-binary[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9ef1153f1443be793eecc3f91a5df9c9f519416667f7fef8329cf5cfb2cca5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2111f22ba9fe50f2d1bbdcd3693e5bc9fa3dfab5687c1b8d6c4fbe613bd9097f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3140d53e065d21df68337e1e597a3e6b76ef7fb9afd06d822ee58e4015e2dad3"
    sha256 cellar: :any_skip_relocation, sonoma:         "fce0cf1e764956c54a79dc97779abe1818d440193eee957278c1ac299986170e"
    sha256 cellar: :any_skip_relocation, ventura:        "2a1d49dfafc87dcb23598e7cc2b43b14ea872b5f7e874e6c3a7aeceaf30e5fae"
    sha256 cellar: :any_skip_relocation, monterey:       "191f3502bef04a28ce52efa3b85843c6c427874fccbfb06df8d5d378afddb317"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f1ff20f82a7f2d9722ff8af351cce768cff44c1346c6eca8de93694f6d0fb466"
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
