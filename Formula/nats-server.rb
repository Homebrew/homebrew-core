class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "4087b1f0bcedab6b352a1ca56f3d6d4cac1890d80627b4b751cb7f08093cf20b"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2018795d0f31e5164091ccc80bfbfba8eb6e5d3ac4cde3c064090247c588e161"
    sha256 cellar: :any_skip_relocation, big_sur:       "355125f15a10784720931df991aea71ad62e7d783257bf4b8e1e752f86037cc6"
    sha256 cellar: :any_skip_relocation, catalina:      "c782b168a7dd01d507772d29a9920b6ecda69dd7919c09109d00e1de39db94c1"
    sha256 cellar: :any_skip_relocation, mojave:        "0fbbaa67e5d541b1fc77f5844393d9dbeb970f95a142333b5a3bea88febec2d8"
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
