class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v9.2.5.tar.gz"
  sha256 "66e9c90b0af9ec5e2a3580e04fdd8c4176c3d73f4890d468f8ed9f108d1e7bca"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2019ed49a3b36c189ce9e78e4693601fd6711cfba9d3205bb7521f7284ef1591"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c554ebafbe8075ede2527c95ffd227ff7a95ee06608577bd7bbc000baec141b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b8aef99c2fe0b1c7cc9f75667da2128fe5115a7dae6bf96393d978c409ee083b"
    sha256 cellar: :any_skip_relocation, ventura:        "2b6d431a768bf160b9d3a70e9823f00e73bba21eea8a3ec17c8244a887a4afb2"
    sha256 cellar: :any_skip_relocation, monterey:       "c24902a648a285c33ab4b7e9b068bed5595553ec9d0dc64f1848dcb7cd5d6b81"
    sha256 cellar: :any_skip_relocation, big_sur:        "a90c0a0d0b7fb59d98cea9ab69cee59df244880128395f35709a3bbb0680774b"
    sha256 cellar: :any_skip_relocation, catalina:       "32ad119b9829f8dba5dc150162fdeb40d6425e6a69a1ade73cc45a3bab1047fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f0553d0a152c05e1e2efd64cefd3b3e7d43361aade72a9935d12c4538ec0b22"
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
