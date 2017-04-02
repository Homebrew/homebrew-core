class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  url "https://github.com/mailhog/MailHog/archive/v0.2.1.tar.gz"
  sha256 "6792dfc51ae439bfec15ac202771e5eaa6053e717de581eb805b6e9c0ed01f49"
  head "https://github.com/mailhog/MailHog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "995a9a7f3bb4feee6e3c33f1bea099cf6781ad1caf6dcb91218785722098a7cb" => :sierra
    sha256 "43adc49f6fabf956f4928c01391ab9a675f2de669fbcf1d2d159ba7c2e04bb65" => :el_capitan
    sha256 "5ce8d3638b11dbea345729539c9691c38dc05b3f0afa8ebecb40829dcc6dbba8" => :yosemite
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
