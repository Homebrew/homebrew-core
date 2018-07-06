class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v1.2.0.tar.gz"
  sha256 "9624ce12adb528e86c03f78305c13f9c5f4edb48cf7b0db123d786f12be00590"
  head "https://github.com/nats-io/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ba43c0294be21d1b57fc8193e9b998e7f9301a68a61a4161aad724f786801520" => :high_sierra
    sha256 "990c795b26ecc35fff73f139b0bebc47066cea4bd92c78d1778b321bd4221ad2" => :sierra
    sha256 "f75e5b2031aca4c47890fb8bfcc6eb6db63eaf41f75efafa9267f771edaad333" => :el_capitan
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
