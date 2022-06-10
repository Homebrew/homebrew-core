class Cnosdb < Formula
  desc "Open source distributed time series database"
  homepage "https://www.cnosdb.com"
  url "https://github.com/cnosdb/cnosdb/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "ae412d0944b64c9b39dc1edc66f7b6f712b85bc5afad354c12b135ae71017100"
  license "MIT"
  head "https://github.com/cnosdb/cnosdb.git"

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath
    system "go", "install", "./..."
    bin.install %w[cnosdb cnosdb-cli cnosdb-ctl cnosdb-meta cnosdb-inspect cnosdb-tools]
    etc.install "etc/cnosdb.sample.toml" => "cnosdb.conf"
    inreplace etc/"cnosdb.conf" do |s|
      s.gsub! "/var/lib/cnosdb/data", "#{var}/cnosdb/data"
      s.gsub! "/var/lib/cnosdb/meta", "#{var}/cnosdb/meta"
      s.gsub! "/var/lib/cnosdb/wal", "#{var}/cnosdb/wal"
    end
    (var/"cnosdb/data").mkpath
    (var/"cnosdb/meta").mkpath
    (var/"cnosdb/wal").mkpath
  end
  plist_options :manual => "cnosdb --config #{HOMEBREW_PREFIX}/etc/cnosdb.conf"

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
            <string>#{opt_bin}/cnosdb</string>
            <string>-config</string>
            <string>#{HOMEBREW_PREFIX}/etc/cnosdb.conf</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/cnosdb.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/cnosdb.log</stringF>
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
    (testpath/"config.toml").write shell_output("#{bin}/cnosdb config")
    inreplace testpath/"config.toml" do |s|
      s.gsub! %r{/.*/.cnosdb/data}, "#{testpath}/cnosdb/data"
      s.gsub! %r{/.*/.cnosdb/meta}, "#{testpath}/cnosdb/meta"
      s.gsub! %r{/.*/.cnosdb/wal}, "#{testpath}/cnosdb/wal"
    end
    begin
      pid = fork do
        exec "#{bin}/cnosdb --config #{testpath}/config.toml"
      end
      sleep 6
      output = shell_output("curl -Is localhost:8086/ping")
      assert_match /X-cnosdb-Version:/, output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
