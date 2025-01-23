class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v11.4.0.tar.gz"
  sha256 "c3a63aade2a86aa360c9b46f4963e60673fc51bb6c54a088d44dfab5a8fb465e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2a17c0012f1c42f8e70f6fba36d84daf57ca22d2f62d3b9b1f39c62d78e4d813"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "328dfb28cbd6f001c1bd02d6cafd6478323745d74aa313a13c7f8d8a963702ac"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3ecaba2e44418a5833a9f3016e943a0cafb17c6d2f877b901054e6493bfc454"
    sha256 cellar: :any_skip_relocation, sonoma:        "7bfb9e105d1d73c032a9b8ba8f82fe3b6a31786efa0fb9763f1772b6d8774fd1"
    sha256 cellar: :any_skip_relocation, ventura:       "758c04af568e1e8fe11db570ad5a5fc9b01e1d7c0d48df59eba66369000df1e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2aea4ca36d6f641b554129140a095c77e42a07bab768454cacf840fa46a6491f"
  end

  depends_on "go" => :build
  depends_on "node" => :build

  uses_from_macos "python" => :build, since: :catalina
  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"

    ENV["COREPACK_ENABLE_DOWNLOAD_PROMPT"] = "0"
    system "corepack", "enable", "--install-directory", buildpath

    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system buildpath/"yarn", "install"
    system buildpath/"yarn", "build"

    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "bin/#{os}-#{arch}/grafana"
    bin.install "bin/#{os}-#{arch}/grafana-cli"
    bin.install "bin/#{os}-#{arch}/grafana-server"

    (etc/"grafana").mkpath
    cp "conf/sample.ini", "conf/grafana.ini.example"
    etc.install "conf/sample.ini" => "grafana/grafana.ini"
    etc.install "conf/grafana.ini.example" => "grafana/grafana.ini.example"
    pkgshare.install "conf", "public", "tools"
  end

  def post_install
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
    require "pty"
    require "timeout"

    # first test
    system bin/"grafana", "server", "-v"

    # avoid stepping on anything that may be present in this directory
    tdir = File.join(Dir.pwd, "grafana-test")
    Dir.mkdir(tdir)
    logdir = File.join(tdir, "log")
    datadir = File.join(tdir, "data")
    plugdir = File.join(tdir, "plugins")
    [logdir, datadir, plugdir].each do |d|
      Dir.mkdir(d)
    end
    Dir.chdir(pkgshare)

    res = PTY.spawn(bin/"grafana", "server",
      "cfg:default.paths.logs=#{logdir}",
      "cfg:default.paths.data=#{datadir}",
      "cfg:default.paths.plugins=#{plugdir}",
      "cfg:default.server.http_port=50100")
    r = res[0]
    w = res[1]
    pid = res[2]

    listening = Timeout.timeout(10) do
      li = false
      r.each do |l|
        if l.include?("HTTP Server Listen")
          li = true
          break
        end
      end
      li
    end

    Process.kill("TERM", pid)
    w.close
    r.close
    listening
  end
end
