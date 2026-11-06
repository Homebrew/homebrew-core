class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v13.3.0.tar.gz"
  sha256 "f38dded2a24994e32f408aec2db1d75a4b5d00217d3ba7c3741d44cdffce4f6e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "16240c0b2cd286e59e3a675e9cbe5d00b4eee82ecbe43e6b63034cf4ce309f4e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1ed2e5d83f54021befd70b69bd393289d9f518cb9e8b5ace319b1671277ed0cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ff1e8e6139da129636ff0ed36f5358dcc4a2664c26105b963e8b3609c72d1ee4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "694a90ba9b567ead1859b3f36ed564f8605fb657e9739d556f5aab6dc763fa5e"
    sha256 cellar: :any,                 x86_64_linux:      "7c5b886f40f7a4f0df60b9fc372bcd606d1d55a2a776731bbb38eee01f1a2f76"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "zlib-ng-compat"
  end

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "go", "mod", "download"
    system "yarn", "install", "--immutable"
  end

  def install
    ENV["COMMIT_SHA"] = tap.user
    ENV["BUILD_NUMBER"] = revision.to_s
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "make", "gen-go"
    system "make", "build-backend"

    # Avoid Nx daemon and plugin worker sockets, which the build sandbox blocks
    ENV["NX_DAEMON"] = "false"
    ENV["NX_ISOLATE_PLUGINS"] = "false"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install buildpath/"bin"/os/arch/"grafana"

    # Require an explicit configuration change to accept remote connections.
    inreplace ["conf/defaults.ini", "conf/sample.ini"], "http_addr =", "http_addr = 127.0.0.1"
    cp "conf/sample.ini", "conf/grafana.ini.example"
    pkgetc.install "conf/sample.ini" => "grafana.ini"
    pkgetc.install "conf/grafana.ini.example"
    pkgshare.install "conf", "public", "tools"

    (var/"log/grafana").mkpath
    (var/"lib/grafana/plugins").mkpath
  end

  service do
    run [opt_bin/"grafana", "server",
         "--config", etc/"grafana/grafana.ini",
         "--homepath", opt_pkgshare,
         "--packaging=brew",
         "cfg:default.paths.logs=#{var}/log/grafana",
         "cfg:default.paths.data=#{var}/lib/grafana",
         "cfg:default.paths.plugins=#{var}/lib/grafana/plugins"]
    keep_alive true
    error_log_path var/"log/grafana-stderr.log"
    log_path var/"log/grafana-stdout.log"
    working_dir var/"lib/grafana"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/grafana --version")

    cp_r pkgshare.children, testpath
    port = free_port
    pid = spawn bin/"grafana", "server", "--homepath", pkgshare,
            "cfg:server.http_port=#{port}",
            "cfg:default.paths.data=#{testpath}/data",
            "cfg:default.paths.logs=#{testpath}/log",
            "cfg:log.mode=file"
    sleep 30
    assert_match "ok", shell_output("curl -fs http://localhost:#{port}/api/health")
    assert_match "address=127.0.0.1:#{port}", (testpath/"log/grafana.log").read
  ensure
    Process.kill("TERM", pid)
  end
end
