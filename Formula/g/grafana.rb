class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v13.3.1.tar.gz"
  sha256 "48a032e9c4a8dec237f3cb9cf8ed58196441625b55d18e0d9978dcf3f97d7801"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6e0c6da98896e937d1298e0e09de75c18017606a6b52ad828372f8469ec4fb0c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "406ac202525b2d9fa0b63c5084a4204fe79c0670cc1e592e042e6e12e18ee385"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "43e2205c36732f2390fc5313dcd57158c0fa74ec187ca8be6d38fddfc7a75ecf"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5d2fb20400a87027e8df4d1713d5be7667323d4b8618f53b2ca4d59305202c4"
    sha256 cellar: :any,                 x86_64_linux:      "5a204e31018c3a13b772b3cd02211c0621c52b8ef835460f4d816956097e6e4f"
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
