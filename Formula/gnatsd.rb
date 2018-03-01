class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v1.0.6.tar.gz"
  sha256 "1e1250591008c59df609f4714f1e91bc97984902cfe2007bc0d042f25cc1ed80"
  head "https://github.com/nats-io/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6681fdcb1047e2ee559791e92a2b9d0eacc9baf18143fa29fdb4a4b2fa70c582" => :high_sierra
    sha256 "2b4a404c578d05d650a716b034022e59797bbf9240b0b4355397c2708329167e" => :sierra
    sha256 "705e36737bc7b921c5e1c92a775ce4e686495ce7cb6622c2bdc13e36fbbca884" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/gnatsd"
    system "go", "build", "-o", bin/"gnatsd", "main.go"
  end

  plist_options :manual => "gnatsd"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/gnatsd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
      </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec bin/"gnatsd",
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
