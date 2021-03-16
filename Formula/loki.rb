class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.2.0.tar.gz"
  sha256 "758fa26422bacda69b12e740e46fa5b97e02063a90fece14fb3fdcd7add2f7f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c0fb0ea99816678e0e25f0e0f27635038c8ad182dc0f7805fbca692352f4b8dd"
    sha256 cellar: :any_skip_relocation, big_sur:       "5ba71a02fd746445c0d2fb9029e276d9d891d62535f3284951409ac0998c93d7"
    sha256 cellar: :any_skip_relocation, catalina:      "56ec75827407729fa6559f782a7ad66b965c65141614ff4ab987a0578a7ae508"
    sha256 cellar: :any_skip_relocation, mojave:        "d672ab0003e81f13c73425e29aa49a7c02e4cf72db4729d4dbd4188eab34c720"
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
