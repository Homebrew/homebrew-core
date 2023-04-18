class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/refs/tags/v9.4.7.tar.gz"
  sha256 "e051cf50cbbf5a7ce4de2d2544b3385464399fa5690713afc17f6c8467e4a0b5"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbbd48c17804dbe1bfd1563f236f266bea783b8ee5ee4013a19c69771d8882b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c004780a04c324b7b642f0fa7f74ecd70d07cc6e42c59ae3c22ecc734f5450e4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec032a30564c7ecc2338754894a26598397181b4b09aedea5ff3c73312d8cfbf"
    sha256 cellar: :any_skip_relocation, ventura:        "130f8408371cd054aafa05e72b5ea76f6427acfae9f5a9ecec22673f165a62b9"
    sha256 cellar: :any_skip_relocation, monterey:       "33b089ed5501776c8ce49b29bfe13c020701bd421e1f64f44e954dd810c02912"
    sha256 cellar: :any_skip_relocation, big_sur:        "6eef810edfe905709b5f29c666baaf88dffbc7c1bb7a2877c91da1ea69b550ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b413852554126735f61b5772003ee587f94fc8922129b331625f6af898267694"
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
