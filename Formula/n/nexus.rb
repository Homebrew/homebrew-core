class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public.git",
      tag:      "release-3.79.1-04",
      revision: "f87adc0e74e44bc26366a851ca96d16922f6f175"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "49a297a1bc820fc4c584bbab2654117b3c92e2045251a7394f764fbb30247656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b6c25b4d6103e37a4a4cf93194483c2db11e0f31ec9b70e7ed16f9631b06815"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7c5268108751d0107d94456f689e4d7aad710143c0c735e6308a81adcdc3c303"
    sha256 cellar: :any_skip_relocation, sonoma:        "87e17682a7e4e0ca6d6353fe0b87ea3d73f0899f3e275a1763d88c86a9086e8f"
    sha256 cellar: :any_skip_relocation, ventura:       "e455e3cce9b4bb8c29de12cec46743f12f051afd35f80a7200f45faf7be96d62"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d9fca47c00f9032e126c9df8cb26f10352ed330e805d8dc89717116664be1ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3082ed2ea92d7ac3e6703f84636fcd9c470ce5b14d7ccf80312df0d5afbce8ff"
  end

  depends_on "maven" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk@17"

  uses_from_macos "unzip" => :build

  # Avoid downloading copies of node and yarn
  patch :DATA

  def install
    # Workaround build error: Couldn't find package "@sonatype/nexus-ui-plugin@workspace:*"
    # Ref: https://github.com/sonatype/nexus-public/issues/417
    # Ref: https://github.com/sonatype/nexus-public/issues/432#issuecomment-2663250153
    inreplace ["components/nexus-rapture/package.json", "plugins/nexus-coreui-plugin/package.json"],
              '"@sonatype/nexus-ui-plugin": "workspace:*"',
              '"@sonatype/nexus-ui-plugin": "*"'

    java_version = "17"
    ENV["JAVA_HOME"] = Language::Java.java_home(java_version)
    java_env = Language::Java.overridable_java_home_env(java_version)
    java_env.merge!(KARAF_DATA: "${NEXUS_KARAF_DATA:-#{var}/nexus}",
                    KARAF_LOG:  var/"log/nexus",
                    KARAF_ETC:  pkgetc)

    with_env(SKIP_YARN_COREPACK_CHECK: "1") do
      system "yarn", "install", "--immutable"
      system "yarn", "workspaces", "run", "build-all"
    end

    system "mvn", "install", "-DskipTests", "-Dpublic"

    assembly = "assemblies/nexus-repository-core/target/assembly"
    rm(Dir["#{assembly}/bin/*.bat"])
    libexec.install Dir["#{assembly}/*"]
    chmod "+x", Dir["#{libexec}/bin/*"]
    (bin/"nexus").write_env_script libexec/"bin/nexus", java_env
  end

  def post_install
    (var/"log/nexus").mkpath unless (var/"log/nexus").exist?
    (var/"nexus").mkpath unless (var/"nexus").exist?
    pkgetc.mkpath unless pkgetc.exist?
  end

  service do
    run [opt_bin/"nexus", "start"]
  end

  test do
    port = free_port
    (testpath/"data/etc/nexus.properties").write "application-port=#{port}"
    pid = spawn({ "NEXUS_KARAF_DATA" => testpath/"data" }, bin/"nexus", "server")
    sleep 50
    sleep 50 if OS.mac? && Hardware::CPU.intel?
    assert_match "<title>Sonatype Nexus Repository</title>", shell_output("curl --silent --fail http://localhost:#{port}")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end

__END__
diff --git a/plugins/nexus-coreui-plugin/pom.xml b/plugins/nexus-coreui-plugin/pom.xml
index 9b8325fd98..2a58a07afe 100644
--- a/plugins/nexus-coreui-plugin/pom.xml
+++ b/plugins/nexus-coreui-plugin/pom.xml
@@ -172,7 +172,7 @@
         <artifactId>karaf-maven-plugin</artifactId>
       </plugin>
 
-      <plugin>
+      <!--plugin>
         <groupId>com.github.eirslett</groupId>
         <artifactId>frontend-maven-plugin</artifactId>
 
@@ -212,12 +212,12 @@
             </goals>
             <phase>test</phase>
             <configuration>
-              <arguments>test --reporters=jest-junit --reporters=default</arguments>
+              <arguments>test -reporters=jest-junit -reporters=default</arguments>
               <skip>${npm.skipTests}</skip>
             </configuration>
           </execution>
         </executions>
-      </plugin>
+      </plugin-->
     </plugins>
   </build>
 
diff --git a/pom.xml b/pom.xml
index 6647497628..d99148b421 100644
--- a/pom.xml
+++ b/pom.xml
@@ -877,7 +877,7 @@
           </executions>
         </plugin>
 
-        <plugin>
+        <!--plugin>
           <groupId>com.github.eirslett</groupId>
           <artifactId>frontend-maven-plugin</artifactId>
           <version>1.11.3</version>
@@ -932,7 +932,7 @@
               </configuration>
             </execution>
           </executions>
-        </plugin>
+        </plugin-->
 
         <plugin>
           <groupId>com.mycila</groupId>
