class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v12.3.3.tar.gz"
  sha256 "b6414bd5e093c5e6457f691e700675b8d48faf4aee9e74e887fc7ae40037f25e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db78c69ea8e7b034bcf44bd17163a48e609cdefa335b731bb19bb4d6bc469361"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2d15f49f2d3f0d0fe0620e757fc023474f430c68e323e1535250912af8bfd7f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1b5a94bf1ba4f000ec78e7bb6ea1b0cbe8cb81256ea37aa18a4896a55a4b3190"
    sha256 cellar: :any_skip_relocation, sonoma:        "18f671ffe8301a242422c211a3c231799d887baf061e35d65d4bc05b0a02e778"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0afe747d34baeaccbd0fbba34e53f050ef41801c9a3bdbdbea6d1c990f005a84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50325ffdf9990b6f4c98667a7d315cbaa3833f2730febb9ad24371bc51bc4bc3"
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
