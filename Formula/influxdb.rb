class Influxdb < Formula
  desc "Time series, events, and metrics database"
  homepage "https://influxdata.com/time-series-platform/influxdb/"
  url "https://github.com/influxdata/influxdb/archive/v1.8.4.tar.gz"
  sha256 "9f2c135c8f9f50ca469196e6b4e575e26f1a338538788e71b664212e03b4df7b"
  license "MIT"
  head "https://github.com/influxdata/influxdb.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0a14b0bb22f27de27b072abf29ab014cc9723e2871904700471f78e6d9f6f030"
    sha256 cellar: :any_skip_relocation, big_sur:       "09ed45e33953ab84c6f5b8a862da62135164a10926c81186ba5587a7f65a0041"
    sha256 cellar: :any_skip_relocation, catalina:      "6d88fe5e33124a220eb70d8e140fdb213b13d465560ef04a8bc3a9b992d1dd94"
    sha256 cellar: :any_skip_relocation, mojave:        "ad332849b3ab8d6a07e58a06a2164ccc207652797f55e396f3845081a006a121"
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
