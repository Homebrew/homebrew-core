class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "4e1b27f7799fe01c6e756af7b98d6632a3085d95028a6719086aa8988c8b54a5"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d5515ee93cf01f74855305a3d6394d67757d0b19808d171923ff8e684385a582"
    sha256 cellar: :any_skip_relocation, big_sur:       "c831dcc8d4d3d773f4a4e413b2872177b183dc1885705f762f3fe7ee4e64329e"
    sha256 cellar: :any_skip_relocation, catalina:      "2603108bae1f6ca111e6fe959fa9c8357e696779e57a363050b89cfddf267432"
    sha256 cellar: :any_skip_relocation, mojave:        "905c010fe2b1a0938ed2042816fb2a6caed455bbacf325b37b1beb47875bdbf6"
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
