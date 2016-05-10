class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://kr.github.io/beanstalkd/"
  url "https://github.com/kr/beanstalkd/archive/v1.10.tar.gz"
  sha256 "923b1e195e168c2a91adcc75371231c26dcf23868ed3e0403cd4b1d662a52d59"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "a1929c324475d482942447e24e4d6da0b9d47ecc7e028d5fa1e743892fe26cdf" => :el_capitan
    sha256 "91b369d07c61cba1344e5d8d6718a1805aa49aacd777c166a6657f86cbaa3282" => :yosemite
    sha256 "cc0f15232d47f0cb95acb6f2e252acb26cf978a564c3711c6d12995ad2598a7d" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :manual => "beanstalkd"

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
          <string>#{opt_bin}/beanstalkd</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/beanstalkd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/beanstalkd.log</string>
      </dict>
    </plist>
    EOS
  end
end
