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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8a3fd80c8008fd25205fb318ee06ae801a7d74d969b1d6f06bf5e7c2fb62b4c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41d2feb6e85f4df82192cf62afdb21e93bf5ea79b8fc163f9d297d4a440f8c39"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "939834966728216f77cd05f37e7be1d40e803615792cbc94510880e22be58514"
    sha256 cellar: :any_skip_relocation, sonoma:        "b368f0bd961164f00b33c38de70810cf24091f457dcfaf96bcbf41ac10102df9"
    sha256 cellar: :any_skip_relocation, ventura:       "1317def65ab1ab74b617e15c16918e3d1eed2bd974007049d942d96ced029a7c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bd720dbef91a776d339d8a3dfd14a4f960a01a40f9388a5503c1c285da8f8be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d5dae4e536f76bf9badb1b6989d8d2a671009767a8324f16b81748471d6fdf2a"
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
