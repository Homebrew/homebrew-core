class Beanstalkd < Formula
  desc "Generic work queue originally designed to reduce web latency"
  homepage "https://beanstalkd.github.io/"
  url "https://github.com/beanstalkd/beanstalkd/archive/v1.11.tar.gz"
  sha256 "5e3414e49d00e9ef9530897983e56bdba98da6f8f1f30f5fe7e6064b2f68c544"

  bottle do
    cellar :any_skip_relocation
    sha256 "25b0295808e5a2656048353cbdb1951f1a2adcec9c0670a8e2f2f3def0a390c7" => :mojave
    sha256 "bb0e40b2cae04860948bb8496c4255185c19bb5b184256623168d9b9731a82ab" => :high_sierra
    sha256 "26ac90328390f5ba74741810df546a6faa99d37f8d124ce1225789794d3568ac" => :sierra
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
