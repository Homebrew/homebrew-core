class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v8.1.7.tar.gz"
  sha256 "08179d4cc19d689ee8e2ca2d903f26f768fe2092d7145912ead46c3335c8d90d"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "afeee53066cf4373eed2da1eca188e0395b8e9381827dc9fa53ecdd0f3c688d3"
    sha256 cellar: :any_skip_relocation, big_sur:       "14f44e3d6dc23c0d9f63ef75da917beb357f32247ab6fabf9f2372d04004817f"
    sha256 cellar: :any_skip_relocation, catalina:      "3c513479e32e6646eb1e69fbb075264ba35a18bf09507094bdebb0c10ee86215"
    sha256 cellar: :any_skip_relocation, mojave:        "4c1418240a997772cb377a3acd87bea9ee0fb6a5b108c0a8d2c9c42cd6d3de73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ea9097fc39003664f13a3beb54d6cc4bf14992f4aa1d7f0a24cd5103b477820"
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
