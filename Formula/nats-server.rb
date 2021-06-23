class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "047e52312356459dfa1b4bfe32d42e4827f07480803a90cf40ab5306dda7dca5"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f41719f33e408ffbdf227f5b6603cfb40764330f380e6b55af130ba0d98001cf"
    sha256 cellar: :any_skip_relocation, big_sur:       "8d432e07f71dd9dc84502b46c162060e940540ac9cde22f0402bb705c72b364b"
    sha256 cellar: :any_skip_relocation, catalina:      "ff3b4441ca3b1ad45a46eabfe5cc01510571d0ffd70d89064cdd6db904168f5d"
    sha256 cellar: :any_skip_relocation, mojave:        "a2ba78057b03278d91b748ced21c6c612e254251b27000059bc55cdee8c61feb"
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
