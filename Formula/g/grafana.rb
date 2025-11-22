class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v12.3.0.tar.gz"
  sha256 "15c5d9368f570a0328a14ebfa062b1d269238f251fda22a49da3540a8162ff76"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f34c8c08f4feb111f9311810041a98215a6decf2a34c4688c5bbb7abe46cf7d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d3b7b21758680d78a6797a46104cbc16b4d714b5f3582ffcd2b7955d50137e42"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd4a8b6e4ea28e111811c57f1f199d92bc2c1c2b953fc2e5bb94a5925d4e26d0"
    sha256 cellar: :any_skip_relocation, sonoma:        "135f5263e4ccda5a1dbb6320d7f5621c6beac13dba50b88c292624c264993fae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e10df8c45c1323ccf8620fd622919947e4bea9b724e7ea0d67cd8f94267cb8f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1979dd80b26df967352752430f40752e5e1bef9cc5fcc43a2163c1ee1f94ae39"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build
  uses_from_macos "zlib"

  on_linux do
    # Workaround for old `node-gyp` that needs distutils.
    # TODO: Remove when `node-gyp` is v10+
    depends_on "python-setuptools" => :build
    depends_on "fontconfig"
    depends_on "freetype"
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
