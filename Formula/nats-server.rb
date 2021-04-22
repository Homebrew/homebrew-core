class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.2.2.tar.gz"
  sha256 "aa2421da9c0605d3bc70f030e8213a3ff6883a724c4ce23709b2526239785032"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a250e38ee10371de0052005ebdfd9d67c15a413af29dac1e1eb70a501504c8ab"
    sha256 cellar: :any_skip_relocation, big_sur:       "19664865780ce13e55a1167963b0c27c33bdc98528402cf588c35ef1a4c6beb3"
    sha256 cellar: :any_skip_relocation, catalina:      "1854a03534a74f73f62aeac6ef5b7a658c62e8cc63f1d2125547ba02114cff56"
    sha256 cellar: :any_skip_relocation, mojave:        "0dbfceb6efdf1610fb9045e1fb48be1a20757417765f6638a9221b1c5929c16d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", *std_go_args
  end

  plist_options manual: "nats-server"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/nats-server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{port}")
    assert_predicate testpath/"log", :exist?
  end
end
