require "language/go"

class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v0.8.0.tar.gz"
  sha256 "a2b19de7679b7c5004c75d0c39b8d5d0bd26590a574284e48660eec3a4f9f0d0"
  head "https://github.com/apcera/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d99d697d76d14242333953722c54bc131b609187398177962d2f7286385f1f3" => :el_capitan
    sha256 "7fcc05bbba92843bb0c8dec5f51d8a0501a73853c9adf4510773076d6c15d9a6" => :yosemite
    sha256 "878c5ed548a057dc3674a38f0931e7e8e7ef92a6038c0a7e0ad27a4243452e3d" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/nats-io/nats" do
    url "https://github.com/nats-io/nats.git",
    :revision => "f46ea4b68042c929eda9a7e3b961f453929d8d9d"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    mkdir_p "src/github.com/nats-io"
    ln_s buildpath, "src/github.com/nats-io/gnatsd"
    system "go", "install", "github.com/nats-io/gnatsd"
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
