class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v9.1.2.tar.gz"
  sha256 "6d15ba3e34c9dd26d1fdf6358e4e02b06b82fa6abea26029df0f2f6f890ba5fd"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edec0554edcf1ec5d7954f3b6275b130419540822a74cf56141d83938e220f0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f157860efc487b97de95de99660c2ac3fb24921dae56c7bf0a6568886d66cca0"
    sha256 cellar: :any_skip_relocation, monterey:       "6c0670c18e944d41157b55419d263a1fc96f9796462e05a8bb9d011f4334f810"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0350c43d682886247c84f920cabfb623c8a9a86a936ec0ec8aeff4bfff6096a"
    sha256 cellar: :any_skip_relocation, catalina:       "a22dc0d0b7134337cb70e6bc76ab69d94abe9296042095f87ec7ef342c949b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e90c746324933f7bdeac415c1678ad7e98fab5f7f9a9a6ff0064406d85272f2"
  end

  depends_on "go" => :build
  depends_on "node@16" => :build
  depends_on "yarn" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install"
    system "yarn", "build"

    if OS.mac?
      bin.install Dir["bin/darwin-*/grafana-cli"]
      bin.install Dir["bin/darwin-*/grafana-server"]
    else
      bin.install "bin/linux-amd64/grafana-cli"
      bin.install "bin/linux-amd64/grafana-server"
    end
    (etc/"grafana").mkpath
    cp("conf/sample.ini", "conf/grafana.ini.example")
    etc.install "conf/sample.ini" => "grafana/grafana.ini"
    etc.install "conf/grafana.ini.example" => "grafana/grafana.ini.example"
    pkgshare.install "conf", "public", "tools"
  end

  def post_install
    (var/"log/grafana").mkpath
    (var/"lib/grafana/plugins").mkpath
  end

  service do
    run [opt_bin/"grafana-server",
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
    system bin/"grafana-server", "-v"

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

    res = PTY.spawn(bin/"grafana-server",
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
        if /HTTP Server Listen/.match?(l)
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
