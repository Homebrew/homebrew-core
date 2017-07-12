class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v1.0.0.tar.gz"
  sha256 "6ea5f775f0a32d9754a1672f93dad2cb1be3f5c8f5ef895741fbe95afc2b0c3d"
  head "https://github.com/nats-io/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a49b9ab02c9800697c0e3aa35c703218e3458f2a587853efe198fc0c4fca7f53" => :sierra
    sha256 "ec39b4e08110a782ea43d876127be5bfeef5ec217c9dcbd9760bf80296bb4d25" => :el_capitan
    sha256 "d183db70b8d9e7b7269137b38e4bf0eac0dfa51f37dd21d233513810a032176f" => :yosemite
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
