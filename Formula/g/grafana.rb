class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v13.1.1.tar.gz"
  sha256 "17338e945f6cba1a308726846ffe53e1a646dbf544603ab022b0af3d476cc98f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4c0913751d35adb83e2ef34e1d65949f0cd38f505d12f154c0fdc836e189d53"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6ab47f61a14aef4d2a16972dfb22b8baf9b46fbe2c94b0c733f782a3cd8b2be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "47b888566345d8f434b32e88ef7c7b4d081b94f1a620cf757f72acfe8ad73b79"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61505deda613fd7f37ba33efabbfad888f692bd3205d774f30a3542bc173cc0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1ccb8231173be60436dc9aa12496c4132abbbabcb62d46618c8d8c234e88d02"
    sha256 cellar: :any,                 x86_64_linux:  "887e677fa0b7e810a73dee6259d547210d3a63c5269d024a97446c5455c81b54"
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

  def install
    ENV["COMMIT_SHA"] = tap.user
    ENV["BUILD_NUMBER"] = revision.to_s
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "make", "gen-go"
    system "make", "build-backend"

    system "yarn", "install", "--immutable"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install buildpath/"bin"/os/arch/"grafana"

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
            "cfg:log.mode=file"
    sleep 30
    assert_match "ok", shell_output("curl -fs http://localhost:#{port}/api/health")
  ensure
    Process.kill("TERM", pid)
  end
end
