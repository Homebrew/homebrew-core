class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul/archive/refs/tags/v1.10.0.tar.gz"
  sha256 "971acdd8b180b95d9ace9a29bd6f954d14719b56c7c5a47eeef66aa278b1c1e3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1536c15781c57b43aef4425a2d483f5a0340df84edbbbd2b26b87cfd2f54a5a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "d313ecdf6787c00f9bad5612c8f47d44402084b6ac8b764293fda0f130a90a67"
    sha256 cellar: :any_skip_relocation, catalina:      "308a9157bca53bfaad991ce9ac623259eb3b40d2a4cf1f6d7608baf86c91888a"
    sha256 cellar: :any_skip_relocation, mojave:        "8289dd1a88faa3ecd0e9c70f22c61cb22e14341518408f8026599f105651e223"
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
