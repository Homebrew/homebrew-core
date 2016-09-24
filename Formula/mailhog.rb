class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  revision 1

  head "https://github.com/mailhog/MailHog.git"

  stable do
    url "https://github.com/mailhog/MailHog/archive/v0.2.0.tar.gz"
    sha256 "e7aebdc9295aa3a4a15198b921e76ec9b1a490d2f3e67d4670b94d816d070f37"

    # These two patches introduce the vendoring system, and fix a build
    # issue that would be introduced by the vendoring system otherwise.
    patch do
      url "https://github.com/mailhog/MailHog/commit/8dfadf408a.patch"
      sha256 "408d90ce37df218a122d2ae5d41c59fed33c4d16a075f25e9d90f046a6efc974"
    end

    patch do
      url "https://github.com/mailhog/MailHog/commit/c68ed81a0c.patch"
      sha256 "a34dddc0387b460a5bb6b673b05301098b37a3ed9313899c519466fcbc8f358c"
    end
  end

  bottle do
    cellar :any_skip_relocation
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
