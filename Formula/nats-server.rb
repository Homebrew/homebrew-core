class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.1.0.tar.gz"
  sha256 "39f0d465b841d116507aa70f8a2c6037f3ee9c0493a8d0d3989391be67946f70"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7bb94a4ab87e4f338425a0a4d0f0589eca7f6dab30f33bbaca12cb5dc412d41" => :mojave
    sha256 "2208224d59db6a06b0843be68492c8ac0c862de3ce9944b2b3244ddd9c2e6f4f" => :high_sierra
    sha256 "b0b94810a6a434a40b94b5dbe07f02d8b1e813ecc084eae6c10d0015a5b119ea" => :sierra
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
