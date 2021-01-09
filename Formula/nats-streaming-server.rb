class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.20.0.tar.gz"
  sha256 "5329c66f6e13d80e915faa4804a2fb6ba112f371aa9c4e9a8bc65734a7a3ca49"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d162bcdfdf6b36c950956d31b756eaf6ad68881e4d0a0c78d6b82a5ed64c7ab" => :big_sur
    sha256 "fa3444ac63515f4f1ecfa69a9257a75814297cafb166a2ccf8eaa3687bd5b988" => :arm64_big_sur
    sha256 "0708b9268e65c6c3cf1b09da7dbb47c8b1068af0d30a29024227a62855a24e28" => :catalina
    sha256 "e568f972d3bb095f70f20b708b2318e5db8fd2e58311140651cd1e0361ac619a" => :mojave
    sha256 "ac0ab25c8c1e58123d3900f408295bae4d38fb99f19923d818b339b0a60c4739" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-streaming-server"
    prefix.install_metafiles
  end

  plist_options manual: "nats-streaming-server"

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
            <string>#{opt_bin}/nats-streaming-server</string>
          </array>
          <key>RunAtLoad</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/nats-streaming-server --port=8085 --pid=#{testpath}/pid --log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "INFO", shell_output("curl localhost:8085")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
