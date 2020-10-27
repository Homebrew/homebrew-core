class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v1.6.1.tar.gz"
  sha256 "25d130f47aa4408ea9def4096253a37d4df4e0c44bdd59aa7e9a69f81e6fbd17"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "407914f713e48ebbb8105b9d6cbb7b1961a39b23b1a6aee73df32d26942d9671" => :catalina
    sha256 "29974a46a0217c4491613fac9e2119d2c2846ad35d076b0472b690e8451078ea" => :mojave
    sha256 "38d7a26d3899aba36fe359f62349dc4b5b592a043bfac76a9162202eb829de1e" => :high_sierra
  end

  depends_on "go" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  plist_options manual: "loki -config.file=#{HOMEBREW_PREFIX}/etc/loki-local-config.yaml"

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
            <string>#{opt_bin}/loki</string>
            <string>-config.file=#{etc}/loki-local-config.yaml</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/loki.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/loki.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
