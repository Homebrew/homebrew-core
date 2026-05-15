class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public.git",
      tag:      "release-3.92.1-05",
      revision: "c3d42772d255dc5a8d8a288620954d2575f49f55"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5509688045aca90f9b68268aae5a4f97b6817ab6bb11d1f1f055b7dceabc581a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8341e98af5aeb33ae30e328fb182758de2f95a2f02b7da4e8ae10f0d106c3320"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9cff12a8196e4ab5594e0bf2cf2409b9059025422e2ff65c897ac5e63a4cabc8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b1781b68548cf1286a4c0aee79fb3d762f417a78e9d4aea2dae8959af9d4535"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5d362f5c726082e95975d5044af5a6dab16c2af3e9b2e1e33c5075dfa327579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a1c257fd9d1c28b67a1086f06f7c9d92cd0aae511a15fa1121576ff66d1d62"
  end

  depends_on "maven" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build
  depends_on "openjdk"

  uses_from_macos "unzip" => :build

  # 1. Avoid downloading copies of node and yarn
  # 2. To avoid non-FIPS provider loads bc-fips classes, use isolated classloader.
  # 3. Add NoopRecoveryModeService to avoid recovery mode that is implemented by private module.
  # 4. Add NoopRepositoryMetricsService to satisfy DI in OSS-only build.
  patch :DATA

  def install
    # Workaround build error: Couldn't find package "@sonatype/nexus-ui-plugin@workspace:*"
    # Ref: https://github.com/sonatype/nexus-public/issues/417
    # Ref: https://github.com/sonatype/nexus-public/issues/432#issuecomment-2663250153
    inreplace "public/common/components/nexus-coreui-plugin/package.json",
              '"@sonatype/nexus-ui-plugin": "workspace:*"',
              '"@sonatype/nexus-ui-plugin": "*"'

    inreplace "package.json" do |s|
      # Drop core-js@^3 resolution (yarn 1.x cannot parse range selector).
      s.gsub!(/^\s*"core-js@\^3":.*\n/, "")
      # Remove platform-locked e2e binding that breaks cross-platform install.
      s.gsub!(%r{^\s*"@rspack/binding-darwin-arm64":.*\n}, "")
    end

    java_version = Formula["openjdk"].version.major.to_s
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

    assembly = "public/selfhosted/assemblies/nexus-repository-core/target/assembly"
    rm(Dir["#{assembly}/bin/*.bat"])
    libexec.install Dir["#{assembly}/*"]
    chmod "+x", libexec.glob("bin/*")
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
diff --git a/pom.xml b/pom.xml
index 6207634..aff32c4 100644
--- a/pom.xml
+++ b/pom.xml
@@ -284,7 +284,7 @@
           </executions>
         </plugin>

-        <plugin>
+        <!--plugin>
           <groupId>com.github.eirslett</groupId>
           <artifactId>frontend-maven-plugin</artifactId>
           <version>1.15.1</version>
@@ -329,7 +329,7 @@
               </configuration>
             </execution>
           </executions>
-        </plugin>
+        </plugin-->

         <plugin>
           <groupId>com.mycila</groupId>
diff --git a/public/common/components/nexus-coreui-plugin/pom.xml b/public/common/components/nexus-coreui-plugin/pom.xml
index 1fc5b81..f5591eb 100644
--- a/public/common/components/nexus-coreui-plugin/pom.xml
+++ b/public/common/components/nexus-coreui-plugin/pom.xml
@@ -181,17 +181,6 @@
         <artifactId>frontend-maven-plugin</artifactId>

         <executions>
-          <execution>
-            <id>js-unit-test</id>
-            <goals>
-              <goal>corepack</goal>
-            </goals>
-            <phase>test</phase>
-            <configuration>
-              <arguments>yarn test --silent --reporters=jest-junit --reporters=default</arguments>
-              <skip>${npm.skipTests}</skip>
-            </configuration>
-          </execution>
         </executions>
       </plugin>
     </plugins>
diff --git a/public/common/components/nexus-ui-plugin/pom.xml b/public/common/components/nexus-ui-plugin/pom.xml
index 1ce0a5f..9072bdd 100644
--- a/public/common/components/nexus-ui-plugin/pom.xml
+++ b/public/common/components/nexus-ui-plugin/pom.xml
@@ -51,17 +51,6 @@
         <artifactId>frontend-maven-plugin</artifactId>

         <executions>
-          <execution>
-            <id>js-unit-test</id>
-            <goals>
-              <goal>corepack</goal>
-            </goals>
-            <phase>test</phase>
-            <configuration>
-              <arguments>yarn test --silent --reporters=jest-junit --reporters=default</arguments>
-              <skip>${npm.skipTests}</skip>
-            </configuration>
-          </execution>
         </executions>
       </plugin>

@@ -132,17 +121,6 @@
                   See: NEXUS-52614
                 -->
                 <!-- Use test-no-lint to avoid arch-specific native modules -->
-                <execution>
-                  <id>js-unit-test</id>
-                  <goals>
-                    <goal>corepack</goal>
-                  </goals>
-                  <phase>test</phase>
-                  <configuration>
-                    <arguments>yarn test-no-lint --silent --reporters=jest-junit --reporters=default</arguments>
-                    <skip>${npm.skipTests}</skip>
-                  </configuration>
-                </execution>
               </executions>
             </plugin>
         </plugins>
diff --git a/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java b/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java
index dfeb6f0..38e067c 100644
--- a/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java
+++ b/public/common/components/nexus-crypto/src/main/java/org/sonatype/nexus/crypto/internal/CryptoHelperImpl.java
@@ -87,8 +87,25 @@ public class CryptoHelperImpl
   }
 
   private static void loadNonFipsProvider() {
-    // BouncyCastleProvider must be set as the last provider
-    Security.addProvider(new BouncyCastleProvider());
+    try {
+      Class<?> providerClass =
+          getNonFipsClassLoader().loadClass("org.bouncycastle.jce.provider.BouncyCastleProvider");
+      Provider provider = (Provider) providerClass.getConstructor().newInstance();
+      // BouncyCastleProvider must be set as the last provider
+      Security.addProvider(provider);
+    }
+    catch (ClassNotFoundException | NoSuchMethodException | InvocationTargetException
+        | InstantiationException | IllegalAccessException e) {
+      throw new RuntimeException("Failed to initialize non-FIPS provider", e);
+    }
+  }
+
+  private static URLClassLoader getNonFipsClassLoader() {
+    // Load bcprov and bcutil in an isolated classloader to prevent bc-fips classes
+    // (which share org.bouncycastle.crypto.* package names) from interfering.
+    URL bcprovUrl = BouncyCastleProvider.class.getProtectionDomain().getCodeSource().getLocation();
+    URL bcutilUrl = org.bouncycastle.util.Arrays.class.getProtectionDomain().getCodeSource().getLocation();
+    return new URLClassLoader(new URL[]{bcprovUrl, bcutilUrl}, null);
   }
 
   private static void loadFipsProvider() {
diff --git a/public/common/components/nexus-scheduling/src/main/java/org/sonatype/nexus/scheduling/internal/NoopRecoveryModeService.java b/public/common/components/nexus-scheduling/src/main/java/org/sonatype/nexus/scheduling/internal/NoopRecoveryModeService.java
new file mode 100644
index 0000000..9279594
--- /dev/null
+++ b/public/common/components/nexus-scheduling/src/main/java/org/sonatype/nexus/scheduling/internal/NoopRecoveryModeService.java
@@ -0,0 +1,26 @@
+package org.sonatype.nexus.scheduling.internal;
+
+import org.sonatype.nexus.scheduling.RecoveryModeService;
+import org.springframework.stereotype.Component;
+
+@Component
+public class NoopRecoveryModeService
+    implements RecoveryModeService
+{
+  @Override
+  public boolean isRecoveryMode() {
+    return false;
+  }
+
+  @Override
+  public void enableRecoveryMode() {
+  }
+
+  @Override
+  public void disableRecoveryMode() {
+  }
+
+  @Override
+  public void ensureNotInRecoveryMode(final String taskName) {
+  }
+}
diff --git a/public/common/components/nexus-repository-services/src/main/java/org/sonatype/nexus/repository/rest/internal/api/NoopRepositoryMetricsService.java b/public/common/components/nexus-repository-services/src/main/java/org/sonatype/nexus/repository/rest/internal/api/NoopRepositoryMetricsService.java
new file mode 100644
index 0000000..0aa21ae
--- /dev/null
+++ b/public/common/components/nexus-repository-services/src/main/java/org/sonatype/nexus/repository/rest/internal/api/NoopRepositoryMetricsService.java
@@ -0,0 +1,28 @@
+package org.sonatype.nexus.repository.rest.internal.api;
+
+import java.util.Collections;
+import java.util.List;
+import java.util.Optional;
+
+import org.sonatype.nexus.repository.rest.api.RepositoryMetricsDTO;
+import org.sonatype.nexus.repository.rest.api.RepositoryMetricsService;
+import org.springframework.stereotype.Component;
+
+@Component
+public class NoopRepositoryMetricsService
+    implements RepositoryMetricsService
+{
+  @Override
+  public Optional<RepositoryMetricsDTO> get(final String repositoryName) {
+    return Optional.empty();
+  }
+
+  @Override
+  public List<RepositoryMetricsDTO> list() {
+    return Collections.emptyList();
+  }
+
+  @Override
+  public void runUpdate() {
+  }
+}
