class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.2.6.tar.gz"
  sha256 "dec863683c0503cac7461970468785f65bc0771a3065f70cd3a0b4c76dd1dda9"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ebc7cd83b585031c9ce24bf783ed3d54412663b8e331ae86793dc21fdc1d687e"
    sha256 cellar: :any_skip_relocation, big_sur:       "931ceeacf3c156e4e84338ecd585438dca7c680289fabb918986e678642b87cf"
    sha256 cellar: :any_skip_relocation, catalina:      "db509f960f3c7aef9f850c0b9987faf59a4b27a199d1590d920535895373ee50"
    sha256 cellar: :any_skip_relocation, mojave:        "ec4164cc6323b8b02f2be1e78b85251584d216cecfe81287cf7434c060f11fff"
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
