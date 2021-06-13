class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.9.6.tar.gz"
  sha256 "6e3c59057d43e9c614cde19499ef70d49e93f1978eb918022721abee7bc19ed8"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2a396a822a98275144d59a0caf3dccef184484b4acd02684b63db15c2b26a52e"
    sha256 cellar: :any_skip_relocation, catalina: "ae11c89db309a6ea6a9ad05a918a53498fa5463de720f082bffa1a51e34d3143"
    sha256 cellar: :any_skip_relocation, mojave:   "d863e04c43a5a89df5b2692ee264e2cbc1836230c50a01bdcb394b1bf7ac6a3f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  plist_options manual: "consul agent -dev -bind 127.0.0.1"

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
            <string>#{opt_bin}/consul</string>
            <string>agent</string>
            <string>-dev</string>
            <string>-bind</string>
            <string>127.0.0.1</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{var}</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/consul.log</string>
          <key>StandardOutPath</key>
          <string>#{var}/log/consul.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    http_port = free_port
    fork do
      # most ports must be free, but are irrelevant to this test
      system(
        "#{bin}/consul",
        "agent",
        "-dev",
        "-bind", "127.0.0.1",
        "-dns-port", "-1",
        "-grpc-port", "-1",
        "-http-port", http_port,
        "-serf-lan-port", free_port,
        "-serf-wan-port", free_port,
        "-server-port", free_port
      )
    end

    # wait for startup
    sleep 3

    k = "brew-formula-test"
    v = "value"
    system "#{bin}/consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output("#{bin}/consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp
  end
end
