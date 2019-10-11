class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.1.0.tar.gz"
  sha256 "39f0d465b841d116507aa70f8a2c6037f3ee9c0493a8d0d3989391be67946f70"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c10d4e8addeb1dd4ff708bfb7571d6fb205aa6babc71c362cb504204f75f43ba" => :catalina
    sha256 "4e2fe1b1837049177c882d32f791de938f96efc5714801b035a8f2788bf2fe89" => :mojave
    sha256 "a1b2d7408b282d44c4ab12563b4e44163553aac7b36ef44458312ed9465e45fc" => :high_sierra
    sha256 "1f61848ed5de9b75450e9d4d3607ee0bdf690785ad954b2dfb139f964477034d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "off"
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/nats-server"
    buildfile = buildpath/"src/github.com/nats-io/nats-server/main.go"
    system "go", "build", "-v", "-o", bin/"nats-server", buildfile
  end

  plist_options :manual => "nats-server"

  def plist; <<~EOS
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
