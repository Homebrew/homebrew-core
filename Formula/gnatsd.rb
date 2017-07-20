class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v1.0.2.tar.gz"
  sha256 "98cad081f019d251a9e7274ccc8c3409c6a5aeeb361a129e09f9220aeee5c599"
  head "https://github.com/nats-io/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e9b543e9f7f8854e5dc04f25046116dd1c866ffd7eb52a667f68116ddd6d5e2" => :sierra
    sha256 "c843845f7a322dc7661d3fa0e038d524432ceac54b4c745caf33eda6d74e5f3a" => :el_capitan
    sha256 "c240659b8207370e2bd36d8dcdd5b03bda9fa0f67031546d5241acd914981795" => :yosemite
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
      exec bin/"gnatsd",
           "--port=8085",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
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
