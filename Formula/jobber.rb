class Jobber < Formula
  desc "Alternative to cron, with better status-reporting and error-handling"
  homepage "https://dshearer.github.io/jobber/"
  url "https://github.com/dshearer/jobber/archive/v1.4.4.tar.gz"
  sha256 "fd88a217a413c5218316664fab5510ace941f4fdb68dcb5428385ff09c68dcc2"
  license "MIT"
  head "https://github.com/dshearer/jobber.git"

  bottle do
    sha256 "d6b20d135d1f3c3a83bbef5a8bd75aee37bbf737731c6e0dc24dfdfbc0985bdd" => :big_sur
    sha256 "b7ae670b701b1ed169771f2bc34822a785614ad33827e049d5c7456c02cf3591" => :arm64_big_sur
    sha256 "f34fec60aef5e18cfc6f5bb8f1e0dbb00a866a01e3e0041d6c8e055ee7c4e27e" => :catalina
    sha256 "6bb3016d2f4200636cd51c237d04039b8bbf285d473acb37589e45fc602caf30" => :mojave
    sha256 "1fafbf17e64ac28355dd28758441f97fbe8b7e633bde0cf48a744918c281f8da" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--libexecdir=#{libexec}", "--sysconfdir=#{etc}",
      "--localstatedir=#{var}"
    system "make", "install"
  end

  plist_options startup: true

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>Program</key>
          <string>#{libexec}/jobbermaster</string>
          <key>RunAtLoad</key>
          <true/>
          <key>KeepAlive</key>
          <true/>
          <key>StandardOutPath</key>
          <string>#{var}/log/jobber.log</string>
          <key>StandardErrorPath</key>
          <string>#{var}/log/jobber.log</string>
        </dict>
      </plist>
    EOS
  end

  test do
    (testpath/".jobber").write <<~EOS
      version: 1.4
      jobs:
        Test:
          cmd: 'echo "Hi!" > "#{testpath}/output"'
          time: '*'
    EOS

    fork do
      exec libexec/"jobberrunner", "#{testpath}/.jobber"
    end
    sleep 3

    assert_match "Hi!", (testpath/"output").read
  end
end
