class Gnatsd < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://github.com/nats-io/gnatsd/archive/v1.3.0.tar.gz"
  sha256 "2cb9a228acfa1932196652f4c50118e55c9b5ea1b1d6549c0f2cdda7edc1fc10"
  head "https://github.com/nats-io/gnatsd.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "54ec93978457b7054de85e5bd364949520d3aed109f7cc8de45d69218bc60a11" => :mojave
    sha256 "68741a973382bdb90d9f969f587db8ab8e3bcc3edb5f71bb4010e0d25622e474" => :high_sierra
    sha256 "dcad1025191f78aa0ea3e5f1f927d56124688a5dfd93e775cdb5040e89526aaa" => :sierra
    sha256 "c5aad266e2bbc534897cd210689071391a100a6fcd726334a4679ecdcc85a00f" => :el_capitan
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
