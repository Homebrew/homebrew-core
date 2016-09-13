class Chromedriver < Formula
  desc "Tool for automated testing of webapps across many browsers"
  homepage "https://sites.google.com/a/chromium.org/chromedriver/"
  url "https://chromedriver.storage.googleapis.com/2.24/chromedriver_mac64.zip"
  version "2.24"
  sha256 "d4f6e13d88ecf20735138f16ab1545e855a42bce41bebe73667a028871777790"

  bottle :unneeded

  def install
    bin.install "chromedriver"
  end

  plist_options :manual => "chromedriver"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>homebrew.mxcl.chromedriver</string>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <false/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/chromedriver</string>
      </array>
      <key>ServiceDescription</key>
      <string>Chrome Driver</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/chromedriver-error.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/chromedriver-output.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    driver = fork do
      exec bin/"chromedriver", "--port=9999", "--log-path=#{testpath}/cd.log"
    end
    sleep 5
    Process.kill("TERM", driver)
    File.exist? testpath/"cd.log"
  end
end
