class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v8.2.4.tar.gz"
  sha256 "d97a4b985c40549503d33bea693949230e7023bc175709de64b63437d2e5c575"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae64f24d141eacda899d8c0eab3738e2597fb50a4683e99ab7f6be5c391dd27f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6af33b21eae6d9cfc12df03c2dac63390a5ae958cb3c6ccfd9c11ce4979f904"
    sha256 cellar: :any_skip_relocation, monterey:       "a729f9066408a1deb56de5b5ff18d2920a55bd5cf5aa648198fea0785636f390"
    sha256 cellar: :any_skip_relocation, big_sur:        "98963bd543af9acec7db865cbbb685dd7988c27188647bb993bd1a59b730e13a"
    sha256 cellar: :any_skip_relocation, catalina:       "73386db14736489cb3258285810224d32836abfaf1ee71a55aa84c45cf38b74f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc0a7de81910a31081643cf582d67b2cc9534287ee5132e7264f16fd4cb4318a"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "fontconfig"
    depends_on "freetype"
  end

  def install
    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install", "--ignore-engines", "--network-concurrency", "1"

    system "node", "--max_old_space_size=4096", "node_modules/webpack/bin/webpack.js",
           "--config", "scripts/webpack/webpack.prod.js"

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
