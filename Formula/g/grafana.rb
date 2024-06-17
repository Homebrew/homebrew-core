class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v11.0.0.tar.gz"
  sha256 "49559685c1aefc03a58f5280af978bcc0c57d6222b79844c91fd0e6957169812"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7c22fae5fc513cfa47750e9fae0066244d628536f11fff9242a7cf330d38af61"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1c49576a9db6e4b4c6dc54dad9067dee39464d0ca6de70f2bffdce7f44066497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cccf177139f7c59a7bb7516ca52b51bc9bc7d439c8632712df4b7e77a089808a"
    sha256 cellar: :any_skip_relocation, sonoma:         "d848b2f2f77484634d24f6f4a314ed0c19282aa8c3b4cf896c2eeadd80d5ad61"
    sha256 cellar: :any_skip_relocation, ventura:        "e2c4aa3a343cd2947d1b87ba49e50921202fc23f39077a5634b331993f8b8c0b"
    sha256 cellar: :any_skip_relocation, monterey:       "475d47fc2c7aadf02b8c8c58b56bc40ccb3683d7a51503674702736f8a42fa91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab07729d279cf1dc36b45d1fda9b9a486bc8b5d1f277f4b34dfcc09a9aacfcef"
  end

  depends_on "go" => :build
  depends_on "node" => :build
  depends_on "yarn" => :build

  uses_from_macos "python" => :build, since: :catalina
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
