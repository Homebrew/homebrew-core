class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      :tag => "v1.3.4",
      :revision => "0c54d8fc744220b8dc70f2987e04e78fec951285"
  head "https://github.com/influxdata/influxdb.git"

  bottle do
    sha256 "6443420cd63129086f59acb0940420bd67baca1af99641478e22554e0cf8e8e1" => :sierra
    sha256 "152d3d9c558a5300465ef475c9e98692cfc2f89581a6677e19febbee8d252451" => :el_capitan
    sha256 "62a0a372f6299aaf2f980390f2895f8e530c8b4369d7422994b06de8fef5ad63" => :yosemite
  end

  depends_on "gdm" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    influxdb_path = buildpath/"src/github.com/influxdata/influxdb"
    influxdb_path.install Dir["*"]
    revision = `git rev-parse HEAD`.strip
    version = `git describe --tags`.strip

    cd influxdb_path do
      system "gdm", "restore"
      system "go", "install",
             "-ldflags", "-X main.version=#{version} -X main.commit=#{revision} -X main.branch=master",
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

  def plist; <<-EOS.undent
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
      sleep 1
      output = shell_output("curl -Is localhost:8086/ping")
      sleep 1
      assert_match /X-Influxdb-Version:/, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
