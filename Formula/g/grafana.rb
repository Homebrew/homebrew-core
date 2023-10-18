class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v10.1.1.tar.gz"
  sha256 "55f8822105d15fcb6e8dbfb16c3636dfa6e08f8fc6cd1f98700adbb6ba28bbb4"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "31f547ed00edb1ac7b60a764fee642f70c1eecb811400974f266861a8efba094"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc80fd27215878f15c86267e46b78a7da31c99ff022285dfa49b09089bedc0bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f0bcc0b0dd381e5222db7a6395a717b4c6e1ab8c8fd916cc395446562518d8f"
    sha256 cellar: :any_skip_relocation, ventura:        "f9e99037d79674a4b14db8f0eda54d373666b473e62d670acba9f73db281308b"
    sha256 cellar: :any_skip_relocation, monterey:       "96fd109b20bd3cf6485e24631828f17510fb9adbbd9e8d8980b5f92094e1aa66"
    sha256 cellar: :any_skip_relocation, big_sur:        "648cb1c891328082032559b3b85cea9a496747b43fb14cdae75637f0a6cfac43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f25d2de91fabe3a65a97fac3365be6f7f073e7dd1a32b5950c19dc8895fcb02"
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
    ENV["NODE_OPTIONS"] = "--max-old-space-size=8000"
    system "make", "gen-go"
    system "go", "run", "build.go", "build"

    system "yarn", "install"
    system "yarn", "build"

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
