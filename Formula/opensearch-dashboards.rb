class OpensearchDashboards < Formula
  desc "Open source visualization dashboards for OpenSearch"
  homepage "https://opensearch.org/docs/dashboards/index/"
  url "https://github.com/opensearch-project/OpenSearch-Dashboards.git",
      tag:      "1.1.0",
      revision: "44d2cb5b4f9a7c641c1fef32ec569bc48ec46979"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "462dc37bc221e9c30afc971d931c7d0fdd50b66b42675e02056d140d49eaf1b3"
  end

  depends_on "python@3.9" => :build
  depends_on "yarn" => :build
  depends_on "node@10" # Switch to `node` after https://github.com/opensearch-project/OpenSearch-Dashboards/issues/406

  def install
    inreplace "package.json", /"node": "10\.\d+\.\d+"/, %Q("node": "#{Formula["node@10"].version}")

    system "yarn", "osd", "bootstrap"
    system "node", "scripts/build", "--release", "--skip-os-packages", "--skip-archives"

    cd "build/opensearch-dashboards-#{version}-darwin-x64" do
      inreplace Dir["bin/*"],
                "NODE=\"${DIR}/node/bin/node\"",
                "NODE=\"#{Formula["node@10"].opt_bin/"node"}\""

      inreplace "config/opensearch_dashboards.yml",
                /#\s*pid\.file: .+$/,
                "pid.file: #{var}/run/opensearchDashboards.pid"

      (etc/"opensearch-dashboards").install Dir["config/*"]
      rm_rf Dir["{config,data,node,plugins}"]

      prefix.install Dir["*"]
    end
  end

  def post_install
    (var/"log/opensearch-dashboards").mkpath

    (var/"lib/opensearch-dashboards").mkpath
    ln_s var/"lib/opensearch-dashboards", prefix/"data" unless (prefix/"data").exist?

    (var/"opensearch-dashboards/plugins").mkpath
    ln_s var/"opensearch-dashboards/plugins", prefix/"plugins" unless (prefix/"plugins").exist?

    ln_s etc/"opensearch-dashboards", prefix/"config" unless (prefix/"config").exist?
  end

  def caveats
    <<~EOS
      Data:    #{var}/lib/opensearch-dashboards/
      Logs:    #{var}/log/opensearch-dashboards/opensearch-dashboards.log
      Plugins: #{var}/opensearch-dashboards/plugins/
      Config:  #{etc}/opensearch-dashboards/
    EOS
  end

  plist_options manual: "opensearch-dashboards"
  service do
    run opt_bin/"opensearch-dashboards"
    log_path var/"log/opensearch-dashboards.log"
    error_log_path var/"log/opensearch-dashboards.log"
  end

  test do
    ENV["BABEL_CACHE_PATH"] = testpath/".babelcache.json"

    (testpath/"data").mkdir
    (testpath/"config.yml").write <<~EOS
      path.data: #{testpath}/data
    EOS

    port = free_port
    fork do
      exec bin/"opensearch-dashboards", "-p", port.to_s, "-c", testpath/"config.yml"
    end
    sleep 15
    output = shell_output("curl -s 127.0.0.1:#{port}")
    # opensearch-dashboards returns this message until it connects to opensearch
    assert_equal "OpenSearch Dashboards server is not ready yet", output
  end
end
