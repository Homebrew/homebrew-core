class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.10.tar.gz"
  sha256 "923b1e195e168c2a91adcc75371231c26dcf23868ed3e0403cd4b1d662a52d59"

  bottle do
    cellar :any_skip_relocation
    sha256 "21cef05beb1ef9976251362105694272b8eaa5622a4496359514f31dc5eafab9" => :mojave
    sha256 "53ea84c7a2dc35bd061a6aebddd0285a57b72cf300846caeacd243a0bf2f07d3" => :high_sierra
    sha256 "95a75ad2e7f06dfff9881762bddeb1fb06319a411165cba0114e4b7c9b1a4103" => :sierra
    sha256 "6665ec5a9a493341134eca920517547340b672513f96317620c5095db3db9499" => :el_capitan
    sha256 "1772e0af60fe42a471437285f29a9c03b52cd8ddd805eaf3339a9d644c4d1bb5" => :yosemite
    sha256 "3d0c54d751784dd7ecfe1b482f30067ade6e7f99ec21d1e87e8f850fe2582f37" => :mavericks
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  plist_options :manual => "beanstalkd"

  def plist; <<~EOS
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

  test do
    system "#{bin}/beanstalkd", "-v"
  end
end
