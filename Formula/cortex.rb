class Cortex < Formula
  desc "Long term storage for Prometheus"
  homepage "https://cortexmetrics.io/"
  url "https://github.com/cortexproject/cortex/archive/v1.9.0.tar.gz"
  sha256 "ccea2c5e11f80dbfbe48081469a61a8b7f7552b4daacebcf3e34360a2c34b59b"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d017961567d530531cf02e8abd8a9cbe12c373be2e961f3689355119a9c5d872"
    sha256 cellar: :any_skip_relocation, big_sur:       "18cef00b1613e68a285bba511ab47163cb738b4be55e08de3cc74ec0bc549ac7"
    sha256 cellar: :any_skip_relocation, catalina:      "455d89816831a3f79cbfd2f71326e82e556d1054a810173751dd949fc8933edc"
    sha256 cellar: :any_skip_relocation, mojave:        "5a23d1b44bb3cd46b12af2140e2f95dd9af786684b87343b3b3c5e94d3e80e42"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/cortex"
    cd "docs/configuration" do
      inreplace "single-process-config.yaml", "/tmp", var
      etc.install "single-process-config.yaml" => "cortex.yaml"
    end
  end

  plist_options manual: "cortex -config.file=#{HOMEBREW_PREFIX}/etc/cortex.yaml"

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
            <string>#{opt_bin}/cortex</string>
            <string>-config.file=#{etc}/cortex.yaml</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/cortex.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/cortex.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port

    cp etc/"cortex.yaml", testpath
    inreplace "cortex.yaml" do |s|
      s.gsub! "9009", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"cortex", "-config.file=cortex.yaml", "-server.grpc-listen-port=#{free_port}" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/services")
    assert_match "Running", output
  end
end
