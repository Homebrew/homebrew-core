class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v6.3.4.tar.gz"
  sha256 "12defd0674a9656e0146f7414fc74b12ff3934b4b6f44e3e7f1f430d88bf357e"
  head "https://github.com/grafana/grafana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8f7a861d7a797b324910974a91aca391eea4e7b8c72f9efa2514d75a3a3d904" => :mojave
    sha256 "7e6780fa77797ea8650f97995d8b4df37a81ef46d92ff861e06cced4c41bcb66" => :high_sierra
    sha256 "0dc25078ba99d6d01406eca4c193ffce4272bde18f4b8342e03100a8bdef12c2" => :sierra
  end

  depends_on "go" => :build
  depends_on "node@10" => :build
  depends_on "yarn" => :build

  def install
    ENV["GOPATH"] = buildpath
    grafana_path = buildpath/"src/github.com/grafana/grafana"
    grafana_path.install buildpath.children

    cd grafana_path do
      system "go", "run", "build.go", "build"

      system "yarn", "install", "--ignore-engines"

      system "node_modules/grunt-cli/bin/grunt", "build"

      bin.install "bin/darwin-amd64/grafana-cli"
      bin.install "bin/darwin-amd64/grafana-server"
      (etc/"grafana").mkpath
      cp("conf/sample.ini", "conf/grafana.ini.example")
      etc.install "conf/sample.ini" => "grafana/grafana.ini"
      etc.install "conf/grafana.ini.example" => "grafana/grafana.ini.example"
      pkgshare.install "conf", "public", "tools", "vendor"
      prefix.install_metafiles
    end
  end

  def post_install
    (var/"log/grafana").mkpath
    (var/"lib/grafana/plugins").mkpath
  end

  plist_options :manual => "grafana-server --config=#{HOMEBREW_PREFIX}/etc/grafana/grafana.ini --homepath #{HOMEBREW_PREFIX}/share/grafana --packaging=brew cfg:default.paths.logs=#{HOMEBREW_PREFIX}/var/log/grafana cfg:default.paths.data=#{HOMEBREW_PREFIX}/var/lib/grafana cfg:default.paths.plugins=#{HOMEBREW_PREFIX}/var/lib/grafana/plugins"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/grafana-server</string>
          <string>--config</string>
          <string>#{etc}/grafana/grafana.ini</string>
          <string>--homepath</string>
          <string>#{opt_pkgshare}</string>
          <string>--packaging=brew</string>
          <string>cfg:default.paths.logs=#{var}/log/grafana</string>
          <string>cfg:default.paths.data=#{var}/lib/grafana</string>
          <string>cfg:default.paths.plugins=#{var}/lib/grafana/plugins</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}/lib/grafana</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/grafana/grafana-stderr.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/grafana/grafana-stdout.log</string>
        <key>SoftResourceLimits</key>
        <dict>
          <key>NumberOfFiles</key>
          <integer>10240</integer>
        </dict>
      </dict>
    </plist>
  EOS
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

    listening = Timeout.timeout(5) do
      li = false
      r.each do |l|
        if l =~ /Initializing HTTPServer/
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
