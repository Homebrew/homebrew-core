class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.1.0.tar.gz"
  sha256 "ceccc4e42a7158ca0bc49903a3fbe31c8cd55f85f50bac8a8bba9843b4f8cd6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f57e122a4f478e15a804faa21fa582282663ef79f1ec1c57bda8dab95fdef241" => :big_sur
    sha256 "b495d1239adcec769d1980888e62d7ab5f525184a1f5526e8e7349bd7f710e98" => :arm64_big_sur
    sha256 "cdafcfbd3692972dfbb0830e3c57f4cfbd325292783d7f96fde9894c9983c2ec" => :catalina
    sha256 "c9e1ad411938e2f224d5b6c6b68c93c9b8405eece3a9fd2e29e3628f03c09708" => :mojave
    sha256 "0177decc1efb4cb56c78a5aa8cc91405800c3e428fead5a53afe18cde8553994" => :high_sierra
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
