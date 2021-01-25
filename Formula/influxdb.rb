class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v1.8.3.tar.gz"
  sha256 "d8b89e324ed7343c1397124ac3cc68c405406faf74e7369e733611cada54656d"
  license "MIT"
  head "https://github.com/influxdata/influxdb.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "d0928a599343518868633d12bc52e8121bd2c44d218a3c913f251f99aea1c658" => :big_sur
    sha256 "edac905379585ed2a862ce83292906e2badbaa9a851befc87fad96c521f3e2a9" => :arm64_big_sur
    sha256 "0a5b9d401065d2ce56013a334702c436370c088909a783371f7e690d97d2911d" => :catalina
    sha256 "bf43407cabefab4b3b76eb35a53ea835e43c6f50beb80c891f564bd06c7f8ca6" => :mojave
    sha256 "958b7dbbb9f7b7879ab9a9bc8b408c3ffe43027557dc7c3a3a9d73257ff6a820" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath

    system "go", "install", "-ldflags", "-X main.version=#{version}", "./..."
    bin.install %w[influxd influx influx_tsm influx_stress influx_inspect]

    etc.install "etc/config.sample.toml" => "influxdb.conf"
    inreplace etc/"influxdb.conf" do |s|
      s.gsub! "/var/lib/influxdb/data", "#{var}/influxdb/data"
      s.gsub! "/var/lib/influxdb/meta", "#{var}/influxdb/meta"
      s.gsub! "/var/lib/influxdb/wal", "#{var}/influxdb/wal"
    end

    (var/"influxdb/data").mkpath
    (var/"influxdb/meta").mkpath
    (var/"influxdb/wal").mkpath
  end

  plist_options manual: "influxd -config #{HOMEBREW_PREFIX}/etc/influxdb.conf"

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
