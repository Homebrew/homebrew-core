class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.1.6.tar.gz"
  sha256 "029d70ffe5e0f38e7741c6e7417ef0ecc88dd178ae5b117f1afa342b43425578"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7e0f067fdd4c961e738fd3e1a0afaca72832e8aec382b06c9f1d568b8b3b4b6a" => :catalina
    sha256 "4069f2d5fecd96aad7e4da8d9dcfaa9140511fb962849aa0b4bab14eaf181a59" => :mojave
    sha256 "65eff25b8df8d5d49c3e07142b475b6f7e91542969bdf02b0b279424c50bdfd9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-server"
    prefix.install_metafiles
  end

  plist_options :manual => "nats-server"

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
    pid = fork do
      exec bin/"nats-server",
           "--port=8085",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match version.to_s, shell_output("curl localhost:8085")
      assert_predicate testpath/"log", :exist?
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
