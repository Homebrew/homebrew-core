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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a23f6c62f61665384886fd282568eb13ebcff3a627680f128d8dec1a28da6d5e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "af2362120a0d5f0e5830c1029029ede0df1a6a6b3e0ea1aca383b650e6ed98d8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2039336b0df29840c289d9f6baccfe7988d6161f8f20039b587f69230412bc04"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7905377388890e5ffdeaf4fddd3c8d8527ad25a002858fa3b5df4c1942a0b910"
    sha256 cellar: :any,                 x86_64_linux:      "dcfc6e44d9f3e2a033a90091442c4992f173fba85e176d0e071f5123f17ac7c4"
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
