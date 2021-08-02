class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "15fdd8dd30781ff3e75f656bf5cea85ef10b15c8f10fccd1cfffec312118e9c3"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d2b9182bf87f649e7b62a0b1027be05e718feb8997b850179677afb95ba69058"
    sha256 cellar: :any_skip_relocation, big_sur:       "45edd16503352ff6f9579e94e459a4862b4525be986173b37b67956d7afae6ef"
    sha256 cellar: :any_skip_relocation, catalina:      "2345cabce1d10900a85a0c9a9f73ec4b0361791dc73f5f25ebd65ba857fd78df"
    sha256 cellar: :any_skip_relocation, mojave:        "2e812a6814daa99bb764361a14fc1d7fb95159dcea9260546548f3aa041530cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0c8bb0cfc6948d5dcdd01dfd1cc96578f8bfa20d4795e21fa4b011ea9ca89f20"
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
