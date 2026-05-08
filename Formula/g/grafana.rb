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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "11c5af829e3c0b5ef2e03871ef967ef50d9eec5742ed84e15e0db4d114ad65c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd7835e215cadb1ed1c8335a0b31b7beddc4224834116ec685500e3bb558353c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a52f2e5fc95bfd3b82f9b6aba637f091dbe83c5b47bfa14402c0404d5ea0ccc4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e3eb8a91c40ccaf0afe6d5fc2d11f21f2b1d7e56db7599b550b59a00a34292b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "08b7fcf520bb525019f379c49f4781a93720772c5890c7ebbafc7d58354d76bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fd1336042149f9f72aee302dcbe3176915f623a7acb9d812d70a28b5cdae7b2"
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
