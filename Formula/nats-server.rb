class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/nats-server/archive/v2.1.7.tar.gz"
  sha256 "2e571b8c23c5ba1b083b2b4822bb2b4aca99692112a0cd4212237a92d5aa1e2e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75373587ef838b12f3ace83a39e8987496d551c786711ccd46c4f1d3c038d44c" => :catalina
    sha256 "66a6cb75b86ccc17aebd7d1494de0fdf06b880186a0e1cbac2eb131e870cf461" => :mojave
    sha256 "2c3f3a8192cc2358a30c0a8d6bccc1bd6faf2f4e49c726dfb8d71606496ea6f1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/"nats-server"
    prefix.install_metafiles
  end

  plist_options manual: "nats-server"

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
