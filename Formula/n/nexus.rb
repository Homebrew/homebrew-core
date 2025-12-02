class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public.git",
      tag:      "release-3.80.0-06",
      revision: "74aa87dcd43439ef2b69d0a5e49d5522b7944261"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cbdb021da2cc6066138e09589e806d1a07ca47626d99c9f4a3ae2f6fb0c778e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c64a1a99d2afc641dde2157e425fe1a1480af05863156d042425e2eb46de3d82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "502879f5c9432a298e842d0b81f38f1f8bb7fadbb6b07f21acac20c5645a0e9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "b9a7a7083af570c7bc74eb35ecf4685fe113f1bcace468f15e49bac4b51d2593"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5d76c559159d879f391d5b7811adebcfab467c93f0f2c43e7a6eef9a50d742d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebbcd5d02c9ace245c37de557a8e814aa5242fd5eefaba4cb1d94c12014e3006"
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

    (var/"log/nexus").mkpath
    (var/"nexus").mkpath
    pkgetc.mkpath
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
