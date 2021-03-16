class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.2.0.tar.gz"
  sha256 "fca2d79dc616b52f3fddd1bc19e6e11d2496ed048c2ca90c6a30d1fbf1b6c20d"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "479136ac4c23c3f6512949545e17507bf5fef810ea4e651b13accc1ae60f81da"
    sha256 cellar: :any_skip_relocation, big_sur:       "cc145e5f9bce4f22b50d9bdffb16d69868c79a1df00aacf6bf580975a31023cd"
    sha256 cellar: :any_skip_relocation, catalina:      "fa6ebe6376e3c5d71272bc0e574c2d9de324b7ebde31e50dbf1891a90ec8cf4f"
    sha256 cellar: :any_skip_relocation, mojave:        "2f2bb3a49e94a185e4afd5de242de47fb21c3e3ac4fc0e1d6b28e294dc38b3db"
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
