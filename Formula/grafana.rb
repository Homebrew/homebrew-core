class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v8.3.0.tar.gz"
  sha256 "e416b87558d34432560f8b7e7f20e376072ddf2900b631080898d66cc6d78029"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a82b7d31b1426ce2c88552567a1b4be7e7c9e09c50f76e245c6e118d2ec3940a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "657fef1c20bb4b3f2d9e8e16ae985d3ab902899159772bdcdf7a05d989464374"
    sha256 cellar: :any_skip_relocation, monterey:       "c74796464be95a639f24dff3ac120399e1da3cd7493ed1efacfe3ecdef75a402"
    sha256 cellar: :any_skip_relocation, big_sur:        "23f9a074b54ccc9d6456a672bf03b2ac2092eeb8160ec32bba5c826280a75360"
    sha256 cellar: :any_skip_relocation, catalina:       "c22296bc6fb7bf0c21035374a210169d007c5810101ff821974af008f55f0c4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "216e754d1d3598e0225d34af819d952be15140506f44689668c5a3726071b656"
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
