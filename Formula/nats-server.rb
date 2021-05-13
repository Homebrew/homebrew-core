class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.2.4.tar.gz"
  sha256 "584432a18c3cff17ce46bdcb226e818228ed8c3ac6aa88ec641915d45600d7e8"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d8b07206949d0180b3a2a399262b9c388115c828417f66fb4c78cb3180dbcd39"
    sha256 cellar: :any_skip_relocation, big_sur:       "deca6a54ef923264e7f6f67f70920d9ac58a544ff8f40a6698e71b00df38f5fc"
    sha256 cellar: :any_skip_relocation, catalina:      "95d3cd53a131baaa8acec13dc01f938071129c96ef4048da7cfbc6f28708b5b0"
    sha256 cellar: :any_skip_relocation, mojave:        "6fbf4225402a363a744c7453f31a42c4105e0ca1d1a532d96319ef87f30c03f7"
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
