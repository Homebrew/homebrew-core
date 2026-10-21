class OpensearchDashboards < Formula
  desc "Open source visualization dashboards for OpenSearch"
  homepage "https://docs.opensearch.org/latest/dashboards/"
  # Build fails if not a git repository
  url "https://github.com/opensearch-project/OpenSearch-Dashboards.git",
      tag:      "3.9.0",
      revision: "def668b5c4ad825dfff980ed0951cca07aa0ac4b"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ab3a7b07fc52d93f4fb5cfbdb2c3eacf3c6c808c4eaaf2d332794b0fb793ba0e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ab3a7b07fc52d93f4fb5cfbdb2c3eacf3c6c808c4eaaf2d332794b0fb793ba0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ab3a7b07fc52d93f4fb5cfbdb2c3eacf3c6c808c4eaaf2d332794b0fb793ba0e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "336f73c1d4b200da1fd28159e14fc394ba474a67cc5a8864d7fb369ceb33ef2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ab22d18044d2d37934d2c2594e727b313c4974962fff13ea4aa2145f415a430b"
  end

  deprecate! date: "2026-10-28", because: "needs deprecated `node@22`"

  depends_on "yarn" => :build
  depends_on "opensearch" => :test
  depends_on "node@22"

  # - Do not download node and discard all actions related to this node
  patch :DATA

  def install
    system "yarn", "osd", "bootstrap"
    system "node", "scripts/build", "--release", "--skip-os-packages", "--skip-archives", "--skip-node-download"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    cd "build/opensearch-dashboards-#{version}-#{os}-#{arch}" do
      inreplace "bin/use_node",
                /NODE=".+"/,
                "NODE=\"#{formula_opt_bin("node@22")}/node\""

      inreplace "config/opensearch_dashboards.yml",
                /#\s*pid\.file: .+$/,
                "pid.file: #{var}/run/opensearchDashboards.pid"

      (etc/"opensearch-dashboards").install Dir["config/*"]
      rm_r(Dir["{config,data,plugins}"])

      prefix.install Dir["*"]
    end

    (var/"log/opensearch-dashboards").mkpath
    (var/"lib/opensearch-dashboards").mkpath
    (var/"opensearch-dashboards/plugins").mkpath
    prefix.install_symlink var/"lib/opensearch-dashboards" => "data"
    prefix.install_symlink var/"opensearch-dashboards/plugins"
    prefix.install_symlink etc/"opensearch-dashboards" => "config"
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch-dashboards/
      Logs:    #{var}/log/opensearch-dashboards/opensearch-dashboards.log
      Plugins: #{var}/opensearch-dashboards/plugins/
      Config:  #{etc}/opensearch-dashboards/
    EOS
  end

  service do
    run opt_bin/"opensearch-dashboards"
    log_path var/"log/opensearch-dashboards.log"
    error_log_path var/"log/opensearch-dashboards.log"
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"

    os_port = free_port
    (testpath/"data").mkdir
    (testpath/"logs").mkdir
    os_pid = spawn formula_opt_bin("opensearch")/"opensearch", "-Ehttp.port=#{os_port}",
                                                               "-Epath.data=#{testpath}/data",
                                                               "-Epath.logs=#{testpath}/logs"

    (testpath/"config.yml").write <<~YAML
      server.host: "127.0.0.1"
      path.data: #{testpath}/data
      opensearch.hosts: ["http://127.0.0.1:#{os_port}"]
    YAML

    osd_port = free_port
    osd_pid = spawn bin/"opensearch-dashboards", "-p", osd_port.to_s, "-c", testpath/"config.yml"

    output = nil

    max_attempts = 100
    attempt = 0

    loop do
      attempt += 1
      break if attempt > max_attempts

      sleep 3

      output = Utils.popen_read("curl", "--location", "--silent", "127.0.0.1:#{osd_port}")
      break if output.present? && output != "OpenSearch Dashboards server is not ready yet"
    end

    assert_includes output, "<title>OpenSearch Dashboards</title>"
  ensure
    Process.kill("TERM", osd_pid)
    Process.wait(osd_pid)
    Process.kill("TERM", os_pid)
    Process.wait(os_pid)
  end
end

__END__
diff --git a/src/dev/build/build_distributables.ts b/src/dev/build/build_distributables.ts
index 40ade0f..ed8125f 100644
--- a/src/dev/build/build_distributables.ts
+++ b/src/dev/build/build_distributables.ts
@@ -64,8 +64,6 @@ export async function buildDistributables(log: ToolingLog, options: BuildOptions
    */
   await run(Tasks.VerifyEnv);
   await run(Tasks.Clean);
-  await run(options.downloadFreshNode ? Tasks.DownloadNodeBuilds : Tasks.VerifyExistingNodeBuilds);
-  await run(Tasks.ExtractNodeBuilds);
 
   /**
    * run platform-generic build tasks
diff --git a/src/dev/build/tasks/create_archives_sources_task.ts b/src/dev/build/tasks/create_archives_sources_task.ts
index 9c0e085..39e1fc3 100644
--- a/src/dev/build/tasks/create_archives_sources_task.ts
+++ b/src/dev/build/tasks/create_archives_sources_task.ts
@@ -42,21 +42,6 @@ export const CreateArchivesSources: Task = {
           destination: build.resolvePathForPlatform(platform),
           log,
         });
-
-        log.debug(
-          'Generic build source copied into',
-          platform.getNodeArch(),
-          'specific build directory'
-        );
-
-        // copy node.js install
-        await scanCopy({
-          source: (await getNodeDownloadInfo(config, platform)).extractDir,
-          destination: build.resolvePathForPlatform(platform, 'node'),
-          log,
-        });
-
-        log.debug('Node.js copied into', platform.getNodeArch(), 'specific build directory');
       })
     );
   },
diff --git a/src/dev/notice/generate_build_notice_text.js b/src/dev/notice/generate_build_notice_text.js
index b32e200..2aab53f 100644
--- a/src/dev/notice/generate_build_notice_text.js
+++ b/src/dev/notice/generate_build_notice_text.js
@@ -48,7 +48,7 @@ export async function generateBuildNoticeText(options = {}) {
 
   const packageNotices = await Promise.all(packages.map(generatePackageNoticeText));
 
-  return [noticeFromSource, ...packageNotices, generateNodeNoticeText(nodeDir, nodeVersion)].join(
+  return [noticeFromSource, ...packageNotices, ''].join(
     '\n---\n'
   );
 }
