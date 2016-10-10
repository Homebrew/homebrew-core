class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  url "https://github.com/mailhog/MailHog/archive/v0.2.1.tar.gz"
  sha256 "6792dfc51ae439bfec15ac202771e5eaa6053e717de581eb805b6e9c0ed01f49"
  head "https://github.com/mailhog/MailHog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae2cc4e74e86634e24dba328424475c238b87886bcf75eb35e42fb53e7f402c6" => :sierra
    sha256 "30feb97181d3d4075ebd417ba7aeb3e5041e1c544b1ecec962b50f32d02760ae" => :el_capitan
    sha256 "a4ada6cbc833f8040a1f0c37c4ed8be58eefc7e6858c049ae1df2f9034ee4944" => :yosemite
    sha256 "215cf3c14a47cd83ff3e8201c822486c2ffb043bf1f5f1a24b3917c71af5367e" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    path = buildpath/"src/github.com/mailhog/MailHog"
    path.install buildpath.children

    cd path do
      system "go", "build", "-o", bin/"MailHog", "-v"
      prefix.install_metafiles
    end
  end

  plist_options :manual => "MailHog"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/MailHog</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mailhog.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mailhog.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/MailHog"
    end
    sleep 2

    begin
      output = shell_output("curl -s http://localhost:8025")
      assert_match "<title>MailHog</title>", output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
