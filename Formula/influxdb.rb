class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb.git",
      :tag => "v1.3.1",
      :revision => "5887e92e8950435ac7e496ff8dada784051284b7"
  head "https://github.com/influxdata/influxdb.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4d032bf3b7fff2e70c0663a476b4aa084bea04197cbafc866e14b8163c90793" => :sierra
    sha256 "8e23c93375e91db64447c9680cf1c3c68eb059f671748a1518f245e2655c75b6" => :el_capitan
    sha256 "792b626c5ba4a681e11f1ecd9582725471f5f7d27c7efa4773407d44c5e81ffa" => :yosemite
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
