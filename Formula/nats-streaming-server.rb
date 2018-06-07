class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-streaming-server/archive/v0.9.2.tar.gz"
  sha256 "5ee44c3d7bfdbdf5b66b7e391f9a031f8b40a9f5eecf6e236a8566268d09a721"
  head "https://github.com/nats-io/nats-streaming-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddcf05d65140d6cee870e68b427381c56332df5e7672131b0c1a6b002243115b" => :high_sierra
    sha256 "4a4d20764def411f59912dce84f3a4e4df5c093c8c6069f41b520213ce7e7d96" => :sierra
    sha256 "0e02e1198f535b8141e97da8f608fe9f1f6a0d52dea01942bc3fa7e5735687c0" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/nats-streaming-server"
    buildfile = buildpath/"src/github.com/nats-io/nats-streaming-server/nats-streaming-server.go"
    system "go", "build", "-v", "-o", bin/"nats-streaming-server", buildfile
  end

  plist_options :manual => "nats-streaming-server"

  def plist; <<~EOS
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
