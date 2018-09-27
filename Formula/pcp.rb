class Pcp < Formula
  desc "Performance Co-Pilot is a system performance and analysis framework"
  homepage "https://pcp.io/"
  url "https://github.com/performancecopilot/pcp/archive/4.1.3.tar.gz"
  sha256 "346caea9df3610319b191b11abdd86c3312eaa20f9db1d9b34bbd9e0204f3939"

  depends_on "pkg-config" => :build
  depends_on "nss"
  depends_on "python"
  depends_on "qt"
  depends_on "readline"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  plist_options :manual => "pcp"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>RunAtLoad</key>         <true/>
        <key>KeepAlive</key>         <true/>
        <key>Label</key>             <string>io.pcp.startup</string>
        <key>ProgramArguments</key>
            <array>
              <string>ln</string>
              <string>-s</string>
              <string>/usr/local/Cellar/pcp/4.1.1/etc/pcp.env</string>
              <string>/etc/pcp.env</string>
            </array>
        <key>ProgramArguments</key>
            <array>
              <string>ln</string>
              <string>-s</string>
              <string>/usr/local/Cellar/pcp/4.1.1/etc/pcp.conf</string>
              <string>/etc/pcp.conf</string>
            </array>
    </dict>
    </plist>
  EOS
  end

  test do
    system "#{etc}/init.d/pmcd", "start"
  end
end
