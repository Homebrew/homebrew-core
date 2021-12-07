class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v8.3.1.tar.gz"
  sha256 "b5b818b3aadc2fbe5b083647e803e7bb96ba8df6239502c4dc8431a7ab9ec3a1"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dbbd2ef50ea8db97ede52ca69f601283cb32c357b5109e328aa92dd08772b96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "840cd0ffce5969f0fabb7e225953ca238e4899b1d9b948dae947e01eec4c6564"
    sha256 cellar: :any_skip_relocation, monterey:       "4ed1933f8674928e3164443b6005a0136102077300f456a30783c75ef47f7568"
    sha256 cellar: :any_skip_relocation, big_sur:        "93f6e2a064d6331091512fb24d8936434fe22c2713c94baf381a085ff748fbae"
    sha256 cellar: :any_skip_relocation, catalina:       "43c988235823da42c1f6935ff1f13b12799530b4e884b0dc2dd96be80561d42f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20c707527f746e55659a26340e2d11cf3fe2d59db4fd3b515358d4f0e0d534f7"
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
    ENV["NODE_OPTIONS"] = "--max-old-space-size=4096"
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
