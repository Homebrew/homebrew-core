class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/grafana.git", branch: "main"

  stable do
    url "https://github.com/grafana/grafana/archive/refs/tags/v12.1.0.tar.gz"
    sha256 "9e2f3f11eff01f8b86c2c232c6a3c3a32fa303589ea9829538ffc867684a4436"

    # Backport fix for node 22.18.0
    patch do
      url "https://github.com/grafana/grafana/commit/20c14c48f4c7f13610b105d17f54b66d0062b212.patch?full_index=1"
      sha256 "180ecb3eadb594211479875f9340055b6ccd250ca27eaf00b31e8ff08b15ec1b"
    end
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b49b84b062b638291eaada0c0775af8a70c9b520b00a97d7b4e6daef3b8518e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6639b084a92df9ee36e004f42f4e6b9408e987bfd16bea116c3065c6c3e27a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "308c3471f361ba71cd9b2045f57e403187047d0b559d87d0c8e2fe2db3b96757"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0c241cdd832abfdbd10e8f6d8b470248734a2c995fe3a1bb999bbd045c6a0215"
    sha256 cellar: :any_skip_relocation, sonoma:        "c595bb5383f6a46cae69cba6aa21dc421c69e6788a574cd932685ac02ec3cbd8"
    sha256 cellar: :any_skip_relocation, ventura:       "4bfab1f08ad02bfcf248cfeeae524792dee393afa0de5b3f8b37bbe922c238c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4e4d396d5276b1b1482cbea776462f399e78a58c437111b3889bbc82dc11972"
  end

  depends_on "go" => :build
  depends_on "node@22" => :build
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

    cp "conf/sample.ini", "conf/grafana.ini.example"
    pkgetc.install "conf/sample.ini" => "grafana.ini"
    pkgetc.install "conf/grafana.ini.example"
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
