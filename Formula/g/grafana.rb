class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v13.3.2.tar.gz"
  sha256 "dd62c63c72fcdf0b334be4dbdc50347559200ad6ca3176e398bf320996d931e3"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "fe957f4862adfdbe3462a117bd587c04e516427ccdb29c2de589915af0bdecac"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "94d380248534adcae3ea92889f9f7cc4e3ddf00eec1c88df5fba7238c6ed9698"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "95a28df8f44f847886c79d4f6473399fd57852ac577580de5590c72e2a9a07a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e60b0767637084a8bcad82eb6c0166088f6ab2df9dd9d11f234943bc2c73fc7d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "61954c073f915402cfa615191b73340e66549ff5ac6932eb2184fcbbeeeb2956"
    sha256 cellar: :any,                 x86_64_linux:      "2f96a3dde1ceac27b3e030c1e4383f3fecc4d625f9151fda484c3addb2ca27ec"
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
