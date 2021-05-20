class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.2.5.tar.gz"
  sha256 "83a467d44dfd6ee6159b968288f201ffc64eb400553241b09c3b8e494eee8df7"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd3e4ee46b9639189aeba70d0aa787a7e93b945aeec4ed3de03dea8d2d5edfdd"
    sha256 cellar: :any_skip_relocation, big_sur:       "1d7fd052874f3d6dc1f24bfb8cd9e4d8168b5b8e99a8fba9c5dd21aae65ee008"
    sha256 cellar: :any_skip_relocation, catalina:      "c8498cce1e3816b1b9912f98eb2068c8f63527e41068fefa4c353ceeaff687eb"
    sha256 cellar: :any_skip_relocation, mojave:        "bac6e1b7b203755206b0f5092a6e45a5e8b8665a161facfebc9a6d33d9919db1"
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
