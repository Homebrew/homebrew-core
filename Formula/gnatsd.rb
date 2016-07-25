class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v0.8.1.tar.gz"
  sha256 "d2040c47b242ccff9703bca4162ee6c6d3e7163e6af0441704680b2c19599ac0"
  head "https://github.com/apcera/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e8a9989c12a1e63374843af5f4183d0454bbf42d4a8e497d820e7a96d04609c" => :el_capitan
    sha256 "3dfc10e4280a74c5fd203fdf27b110b2d9cb6ea9c1184a7f3107e0df927525e7" => :yosemite
    sha256 "a5f81cb6646f4c7d19d035cb7f8b4de02c946200702ec38983f677ea6e89a73f" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/gnatsd"
    system "go", "build", "-o", bin/"gnatsd", "main.go"
  end

  plist_options :manual => "gnatsd"

  def plist; <<-EOS.undent
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
      exec "#{bin}/gnatsd --port=8085 --pid=#{testpath}/pid --log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match version.to_s, shell_output("curl localhost:8085")
      assert File.exist?(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
