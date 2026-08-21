class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public.git",
      tag:      "release-3.95.1-01",
      revision: "b45a6e13616cd3253e992964dcd41cb79f10a4f8"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0b7f54d3516fdd829e29e83783a9ffbeac5af5e03c1cfc98a9d9fe9f47ce9958"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc6a111a3a6c0418b497551c405e6b324eea05729b92784b1d13bfc91880f86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "509a2d50bfc91e3f7925ccaff0b47acc856a3bec8aadf34a10968f30338a211c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9640301fc8f3c60e5123d20c0a0d59ddcd9df48bd887f26d50e22ff09a2ee1b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f5a350a969fbced1c186a6961976dfa13ddf5196d26e9dacf95df12eabcee81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5a13a5a7c10c9084a464635621c12bf63b3e6ec5fc08f30194b903594cae526"
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
