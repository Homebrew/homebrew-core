class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v8.1.0.tar.gz"
  sha256 "5ab5456b3bdf79a48ad6e5cb6ba3c7c8418f2ab01540e34c77f8fe561c1812ec"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7ba3caa9c60ce7f874a12f33a4d0f45fe9df884936d709de06b365fa9f9c2d1c"
    sha256 cellar: :any_skip_relocation, big_sur:       "aa7246d7ab9026d5dfce038a8cc1d2668a1ffb120b8ab8642c50c5e9da3ca6d1"
    sha256 cellar: :any_skip_relocation, catalina:      "f5648b8e9a9653e20982237d28f36c2d7b89d28351e7a0edf4fbcbbf172da1cf"
    sha256 cellar: :any_skip_relocation, mojave:        "00a407c7ecbe5bfc5024a5dc2f1ceaa1d500b831e35440ce05eab70808379a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e725cb93df282cb71e29c7677e29c20c8a5961b902617e57ffdcae8cb6bd2d61"
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
    system "go", "run", "build.go", "build"

    system "yarn", "install", "--ignore-engines", "--network-concurrency", "1"

    system "node_modules/webpack/bin/webpack.js", "--config", "scripts/webpack/webpack.prod.js"

    on_macos do
      bin.install Dir["bin/darwin-*/grafana-cli"]
      bin.install Dir["bin/darwin-*/grafana-server"]
    end
    on_linux do
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
