class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v8.2.2.tar.gz"
  sha256 "163c33eda935204f3715351c04ce3bd7d08e2937d02b55bffd4d7378eafee79b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3631b3a58dbfce8b9beef019f764caf241c1a864bd00edc37f05c22849001223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d384e50ebe9c4fe2fb5783a5214cdc0fde921d8ef5c39f1748d3762c2c8f6df9"
    sha256 cellar: :any_skip_relocation, monterey:       "fbae313e4bb3bd8f153f5c7cc7d65218862b5c856d8796cce88efc418867650f"
    sha256 cellar: :any_skip_relocation, big_sur:        "54d3fa816b1101d9bdc35a00b27017a0d9b3374c742b787f7518d62e4519e625"
    sha256 cellar: :any_skip_relocation, catalina:       "271394d0f1c48293916e8fef1d98d86f3f9c0ee1a6e9cc1eda83274363ec0980"
    sha256 cellar: :any_skip_relocation, mojave:         "b630f24c8495f8d0cae278fe6ac412a35fa915ba3507e0a963fc65e7c4e70159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8668b14f36f31680e6ec272effd0bcf416db1927b98cfc1cb3f8c3a30e07003d"
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
