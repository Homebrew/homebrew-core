class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "985ea979dfca97147990890ece6f2adf2693e1a3099a539ce1d10bc50e112584"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9be2609ce840d930ab8af971bcf44d9de61bbc46bec63bbc3484e14e12242f5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "157920249839378cde79aaaba25d1f056e920f585264c9a3997dec24a2705e2d"
    sha256 cellar: :any_skip_relocation, catalina:      "c4d69156733127d07d33a992581e33c8d063d519748b775a47a4652cdf4a47d5"
    sha256 cellar: :any_skip_relocation, mojave:        "91af5c5e089413dce3612922ee82514626c416f71b5d9049393f19d529df7066"
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
