class Grafana < Formula
  desc "Gorgeous metric visualizations and dashboards for timeseries databases"
  homepage "https://grafana.com"
  url "https://github.com/grafana/grafana/archive/v7.3.6.tar.gz"
  sha256 "865535b2dff64d4bb5a40d02c462f5cd39f5956f2f2e71464cc40b37e7ec74ac"
  license "Apache-2.0"
  head "https://github.com/grafana/grafana.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a103d949b41c57fa2dd19adee85cadf3e3635e9d11c24a9f7c906c90b24b5d86" => :big_sur
    sha256 "ea0caebf54a5f6ecc76a7a3bd3ffb162e09072bb8755fa42bb693e4344b83f4c" => :catalina
    sha256 "4fc4d9a273ea336fffbc2a331bb2ddf4e6851227d8db38f95d98ded30cd7c73a" => :mojave
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

    system "yarn", "install", "--ignore-engines"

    system "node_modules/grunt-cli/bin/grunt", "build"

    on_macos do
      bin.install "bin/darwin-amd64/grafana-cli"
      bin.install "bin/darwin-amd64/grafana-server"
    end
    on_linux do
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

  plist_options manual: "grafana-server --config=#{HOMEBREW_PREFIX}/etc/grafana/grafana.ini --homepath #{HOMEBREW_PREFIX}/share/grafana --packaging=brew cfg:default.paths.logs=#{HOMEBREW_PREFIX}/var/log/grafana cfg:default.paths.data=#{HOMEBREW_PREFIX}/var/lib/grafana cfg:default.paths.plugins=#{HOMEBREW_PREFIX}/var/lib/grafana/plugins"

  def plist
    <<~EOS
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
