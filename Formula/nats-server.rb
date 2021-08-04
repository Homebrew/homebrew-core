class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "58bbd2c7f33b04b14aea7ccf2c5975e1376e121aee77bf75094dabcfed0f3b39"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36d58ccb50a6a717e1089cf96400fab7e563f36fa8b4c95deff9aa62f513764d"
    sha256 cellar: :any_skip_relocation, big_sur:       "c28f1adbb2f374c055b4e3f23e1d62093a0c94720d55e3185ccac1f163880b51"
    sha256 cellar: :any_skip_relocation, catalina:      "ae6264913877ded34d4128f5937aea3c6202cbe192630e5449c1e0a192044fdf"
    sha256 cellar: :any_skip_relocation, mojave:        "cfdb170113b00135635939417283dcff248668061b92031044d5119d3d1d75f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9792e45f14095120e50c212ceab4f4ebaae24d13153a81aeeec9f78a500ed30e"
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
