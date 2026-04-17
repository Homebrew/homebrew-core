class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v13.0.1.tar.gz"
  sha256 "0bf4d3275c9fe32184ad6c79004928da7436d8a94e0cfb7ded4216080940b54a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f05020704fcaff9e3bfc95eee37486c59c454f81eae17d5df0fa1b2b8abd5441"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "eddb62b529b9fd0f345a0af0fb4c31216f5c92b1f27b6ba5c094facfb7bac2ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b4e4900cfb920b8317a83e8933d133423e15a4dcf741ecc8b266c3a9aabb450c"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff3f577f1fb4493ab662de17bedbda2ac3215359d2d6c04fab57aa0f9192df04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a3096ceb6d2b1f01425c1d227222b7db86afc85b7a0954b818734a5ed1fb759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "03a67a093c65b714e01fd5268cb088f2a9253e545d1a3b7f10c7caa5fefb361c"
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
    # Fix version and should remove in next release
    inreplace "package.json", "13.0.0-pre", "13.0.1-pre"

    ENV["COMMIT_SHA"] = tap.user
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    ENV["npm_config_build_from_source"] = "true"

    system "make", "gen-go"
    system "make", "build-backend"

    system "yarn", "install", "--immutable"
    system "yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install buildpath/"bin/#{os}/#{arch}/grafana"

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
    sleep 20
    assert_equal "Ok", shell_output("curl --silent localhost:#{port}/api/health")
  ensure
    Process.kill("TERM", pid)
  end
end
