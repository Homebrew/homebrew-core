class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v9.3.1.tar.gz"
  sha256 "d26b906c0d98e861a80f8c2db56ca1eb910afb7ddf337c207286c9698c9af38a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18f4eb2398f42ef6cb36dcf188bc11dac2f509099478305a4631b39995455966"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fcc148fb930a526bc1cc84f27a3a88ca972e773cf94c64b9e34b4eca0eb3ab71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5a22a171784c34a5f10c59b7012bdc952198bcb7f463f5faf94604802043347"
    sha256 cellar: :any_skip_relocation, ventura:        "054d9da9ad76d2926927df0a890fafbadb622acea328f676e42d67d8315ddb11"
    sha256 cellar: :any_skip_relocation, monterey:       "f14727cfc29a34d9e81f699c3287b5ab4caba54226010f33f084e663971634af"
    sha256 cellar: :any_skip_relocation, big_sur:        "82e0563a23e928f717241d27146c7f5727ba761a672dde97ea091ada71403346"
    sha256 cellar: :any_skip_relocation, catalina:       "d8c955e2d04d19f8def635b6bb5c7f4997361402c13a41578e2e20c8355c79ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4862098417434024c12bf7b2bbdab86a8de5102e58c3f4d3a5663ad385dbee1"
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
