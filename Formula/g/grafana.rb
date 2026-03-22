class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v12.4.1.tar.gz"
  sha256 "4d3fa7dc9160aa427602b798273016d745a82a536d67d941de720d2a906801f6"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "800ef7c7a3dce22996a6dc0ce686228427313e492694480fcc3b6988b3219b40"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d040cf1d8944022331c0cb80299f6f11b2011d16a360e6781411360f20bb9c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "edb500a29c0e55747069e420a9b5aabe7d4de83791cca28c53a2fb7a822e28c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "18ee074275e92a1907ac9fc80c3f4a60e5feec37ad2835296145ff5bff5f7318"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bac38afa478fe7444fba727e9610b8b50299e7ec082d52b2a03cb4f57117c000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95050e1723b3851a0648ff9142f024a573b53a575fab46ee993b947b651c8ee0"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
    depends_on "fontconfig"
    depends_on "freetype"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["COMMIT_SHA"] = tap.user
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install", "--immutable"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install buildpath.glob("bin/#{os}-#{arch}/grafana{,-cli,-server}")

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
    assert_match version.to_s, shell_output("#{bin}/grafana server --version")

    cp_r pkgshare.children, testpath
    port = free_port
    pid = spawn bin/"grafana", "server", "cfg:server.http_port=#{port}", "cfg:log.mode=file"
    sleep 15
    assert_equal "Ok", shell_output("curl --silent localhost:#{port}/healthz")
  ensure
    Process.kill("TERM", pid)
  end
end
