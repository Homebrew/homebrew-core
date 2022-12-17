class Opensearch < Formula
  desc "Open source distributed and RESTful search engine"
  homepage "https://github.com/opensearch-project/OpenSearch"
  url "https://github.com/opensearch-project/OpenSearch/archive/2.4.1.tar.gz"
  sha256 "df87d5aac8b44aa08788394723d8d458b6bc3b0808aa5891bd9797959921c632"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f7f361c67e838d435da4ac0985525e52993ad6f7a2c93b24c3bf6361442d45d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f7f361c67e838d435da4ac0985525e52993ad6f7a2c93b24c3bf6361442d45d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f7f361c67e838d435da4ac0985525e52993ad6f7a2c93b24c3bf6361442d45d"
    sha256 cellar: :any_skip_relocation, ventura:        "ec0f8d465b277f1213c388ad4f4083846419f17f1820a6ce22355fc20fe08543"
    sha256 cellar: :any_skip_relocation, monterey:       "ec0f8d465b277f1213c388ad4f4083846419f17f1820a6ce22355fc20fe08543"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec0f8d465b277f1213c388ad4f4083846419f17f1820a6ce22355fc20fe08543"
    sha256 cellar: :any_skip_relocation, catalina:       "ec0f8d465b277f1213c388ad4f4083846419f17f1820a6ce22355fc20fe08543"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34da305ad5937ff395c86a0d3ec85163c759203bd7b3f861787b63e1c313e6cc"
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  # Compatibility with Gradle 7.6
  # Based on https://github.com/opensearch-project/OpenSearch/commit/ab85c67bb002e2fb440be659cf156b3f5c06e0f1
  patch :DATA

  def install
    platform = OS.kernel_name.downcase
    platform += "-arm64" if Hardware::CPU.arm?
    system "gradle", "-Dbuild.snapshot=false", ":distribution:archives:no-jdk-#{platform}-tar:assemble"

    mkdir "tar" do
      # Extract the package to the tar directory
      system "tar", "--strip-components=1", "-xf",
        Dir["../distribution/archives/no-jdk-#{platform}-tar/build/distributions/opensearch-*.tar.gz"].first

      # Install into package directory
      libexec.install "bin", "lib", "modules"

      # Set up Opensearch for local development:
      inreplace "config/opensearch.yml" do |s|
        # 1. Give the cluster a unique name
        s.gsub!(/#\s*cluster\.name: .*/, "cluster.name: opensearch_homebrew")

        # 2. Configure paths
        s.sub!(%r{#\s*path\.data: /path/to.+$}, "path.data: #{var}/lib/opensearch/")
        s.sub!(%r{#\s*path\.logs: /path/to.+$}, "path.logs: #{var}/log/opensearch/")
      end

      inreplace "config/jvm.options", %r{logs/gc.log}, "#{var}/log/opensearch/gc.log"

      # add placeholder to avoid removal of empty directory
      touch "config/jvm.options.d/.keepme"

      # Move config files into etc
      (etc/"opensearch").install Dir["config/*"]
    end

    inreplace libexec/"bin/opensearch-env",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"$OPENSEARCH_HOME\"/config; fi",
              "if [ -z \"$OPENSEARCH_PATH_CONF\" ]; then OPENSEARCH_PATH_CONF=\"#{etc}/opensearch\"; fi"

    bin.install libexec/"bin/opensearch",
                libexec/"bin/opensearch-keystore",
                libexec/"bin/opensearch-plugin",
                libexec/"bin/opensearch-shard"
    bin.env_script_all_files(libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix)
  end

  def post_install
    # Make sure runtime directories exist
    (var/"lib/opensearch").mkpath
    (var/"log/opensearch").mkpath
    ln_s etc/"opensearch", libexec/"config" unless (libexec/"config").exist?
    (var/"opensearch/plugins").mkpath
    ln_s var/"opensearch/plugins", libexec/"plugins" unless (libexec/"plugins").exist?
    # fix test not being able to create keystore because of sandbox permissions
    system bin/"opensearch-keystore", "create" unless (etc/"opensearch/opensearch.keystore").exist?
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch/
      Logs:    #{var}/log/opensearch/opensearch_homebrew.log
      Plugins: #{var}/opensearch/plugins/
      Config:  #{etc}/opensearch/
    EOS
  end

  plist_options manual: "opensearch"
  service do
    run opt_bin/"opensearch"
    working_dir var
    log_path var/"log/opensearch.log"
    error_log_path var/"log/opensearch.log"
  end

  test do
    port = free_port
    (testpath/"data").mkdir
    (testpath/"logs").mkdir
    fork do
      exec bin/"opensearch", "-Ehttp.port=#{port}",
                             "-Epath.data=#{testpath}/data",
                             "-Epath.logs=#{testpath}/logs"
    end
    sleep 60
    output = shell_output("curl -s -XGET localhost:#{port}/")
    assert_equal "opensearch", JSON.parse(output)["version"]["distribution"]

    system "#{bin}/opensearch-plugin", "list"
  end
end

__END__
--- a/buildSrc/src/main/java/org/opensearch/gradle/info/GlobalBuildInfoPlugin.java
+++ b/buildSrc/src/main/java/org/opensearch/gradle/info/GlobalBuildInfoPlugin.java
@@ -45,6 +45,7 @@ import org.gradle.api.provider.ProviderFactory;
 import org.gradle.internal.jvm.Jvm;
 import org.gradle.internal.jvm.inspection.JvmInstallationMetadata;
 import org.gradle.internal.jvm.inspection.JvmMetadataDetector;
+import org.gradle.jvm.toolchain.internal.InstallationLocation;
 import org.gradle.util.GradleVersion;

 import javax.inject.Inject;
@@ -52,6 +53,8 @@ import java.io.File;
 import java.io.FileInputStream;
 import java.io.IOException;
 import java.io.UncheckedIOException;
+import java.lang.invoke.MethodHandles;
+import java.lang.invoke.MethodType;
 import java.nio.charset.StandardCharsets;
 import java.nio.file.Files;
 import java.nio.file.Path;
@@ -196,7 +199,29 @@ public class GlobalBuildInfoPlugin implements Plugin<Project> {
     }

     private JvmInstallationMetadata getJavaInstallation(File javaHome) {
-        return jvmMetadataDetector.getMetadata(javaHome);
+        final InstallationLocation location = new InstallationLocation(javaHome, "Java home");
+
+        try {
+            try {
+                // The getMetadata(File) is used by Gradle pre-7.6
+                return (JvmInstallationMetadata) MethodHandles.publicLookup()
+                    .findVirtual(JvmMetadataDetector.class, "getMetadata", MethodType.methodType(JvmInstallationMetadata.class, File.class))
+                    .bindTo(jvmMetadataDetector)
+                    .invokeExact(location.getLocation());
+            } catch (NoSuchMethodException | IllegalAccessException ex) {
+                // The getMetadata(InstallationLocation) is used by Gradle post-7.6
+                return (JvmInstallationMetadata) MethodHandles.publicLookup()
+                    .findVirtual(
+                        JvmMetadataDetector.class,
+                        "getMetadata",
+                        MethodType.methodType(JvmInstallationMetadata.class, InstallationLocation.class)
+                    )
+                    .bindTo(jvmMetadataDetector)
+                    .invokeExact(location);
+            }
+        } catch (Throwable ex) {
+            throw new IllegalStateException("Unable to find suitable JvmMetadataDetector::getMetadata", ex);
+        }
     }

     private List<JavaHome> getAvailableJavaVersions(JavaVersion minimumCompilerVersion) {
@@ -206,7 +231,7 @@ public class GlobalBuildInfoPlugin implements Plugin<Project> {
             String javaHomeEnvVarName = getJavaHomeEnvVarName(Integer.toString(version));
             if (System.getenv(javaHomeEnvVarName) != null) {
                 File javaHomeDirectory = new File(findJavaHome(Integer.toString(version)));
-                JvmInstallationMetadata javaInstallation = jvmMetadataDetector.getMetadata(javaHomeDirectory);
+                JvmInstallationMetadata javaInstallation = getJavaInstallation(javaHomeDirectory);
                 JavaHome javaHome = JavaHome.of(version, providers.provider(() -> {
                     int actualVersion = Integer.parseInt(javaInstallation.getLanguageVersion().getMajorVersion());
                     if (actualVersion != version) {
