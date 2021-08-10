class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.4.tar.gz"
  sha256 "58bbd2c7f33b04b14aea7ccf2c5975e1376e121aee77bf75094dabcfed0f3b39"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9d5df8e187ebb23873fd3508b61918228616bca2f5ccc59fa8ca78ff2e4dcf56"
    sha256 cellar: :any_skip_relocation, big_sur:       "03901b69134159142664481989f808f3fa540e7d5e5bc5b720f92a6371c32711"
    sha256 cellar: :any_skip_relocation, catalina:      "0aadd268fb0ae104649a867836111816d2e4163e3eb8fb8459dbc50bb108f32d"
    sha256 cellar: :any_skip_relocation, mojave:        "68ac3dc35df36dc89216a91a05352bb459850e4f685ae2d94c6f0c8f0ff571b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82584511da9578d54ad1cd2d677fa5a35d4de3e47d3f53c89fdffb87208642b3"
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
