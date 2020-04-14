class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      :tag      => "v1.8.0",
      :revision => "781490de48220d7695a05c29e5a36f550a4568f5"
  head "https://github.com/influxdata/influxdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "43172c67fa138aaed080a19dca1311ad8b4beccc0b70bce8bf10703328806f10" => :catalina
    sha256 "68d9383fb468504f40c8d9992cae8f4ec8dbda502ca4073f0249daa6cfde9a87" => :mojave
    sha256 "fd216a7b67395f3a7ab19affcc51a3dcb71e978f5295daeda871933601dfe6be" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    influxdb_path = buildpath/"src/github.com/influxdata/influxdb"
    influxdb_path.install Dir["*"]
    revision = `git rev-parse HEAD`.strip
    version = `git describe --tags`.strip

    cd influxdb_path do
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision} -X main.branch=master-1.x",
             "./..."
    end

    inreplace influxdb_path/"etc/config.sample.toml" do |s|
      s.gsub! "/var/lib/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/lib/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/lib/influxdb/wal", "#{var}/influxdb/wal"
    end

    bin.install "bin/influxd"
    bin.install "bin/influx"
    bin.install "bin/influx_tsm"
    bin.install "bin/influx_stress"
    bin.install "bin/influx_inspect"
    etc.install influxdb_path/"etc/config.sample.toml" => "influxdb.conf"

    (var/"influxdb/data").mkpath
    (var/"influxdb/meta").mkpath
    (var/"influxdb/wal").mkpath
  end

  plist_options :manual => "influxd -config #{HOMEBREW_PREFIX}/etc/influxdb.conf"

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
            <string>#{opt_bin}/influxd</string>
            <string>-config</string>
            <string>#{HOMEBREW_PREFIX}/etc/influxdb.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/influxdb.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/influxdb.log</string>
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
    (testpath/"config.toml").write shell_output("#{bin}/influxd config")
    inreplace testpath/"config.toml" do |s|
      s.gsub! %r{/.*/.influxdb/data}, "#{testpath}/influxdb/data"
      s.gsub! %r{/.*/.influxdb/meta}, "#{testpath}/influxdb/meta"
      s.gsub! %r{/.*/.influxdb/wal}, "#{testpath}/influxdb/wal"
    end

    begin
      pid = fork do
        exec "#{bin}/influxd -config #{testpath}/config.toml"
      end
      sleep 6
      output = shell_output("curl -Is localhost:8086/ping")
      assert_match /X-Influxdb-Version:/, output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
