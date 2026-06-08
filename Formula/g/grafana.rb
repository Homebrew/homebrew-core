class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v13.0.2.tar.gz"
  sha256 "3f6ccffda94137c9679d0993312a83a76815406efd3df7dabbb8f99467e7e8c6"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30ba252670534f70743352246d39fe1e38061520cd3297361f872197b3d43e4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "84438a1b70ab4ce83881739cb6ca2b8d77e721b79e8afa75d7214e8f5606a790"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3b95703b95ddbd3a0d10ae65cf266a60cfd2d50cd8352aa60bd03f107ffeb6e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1e720ede1c1860c92e46a22ed985f2c79dc61fef7c14a2dd377756ef5789e6bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5282a0205e5c8e2ad9191519a757a3f966d60b73db36cdc50578596cbdb2adc4"
    sha256 cellar: :any,                 x86_64_linux:  "f812eb3408a056d01fb086630ab385e7a77f3169ff00360086dc75b1f008653f"
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
