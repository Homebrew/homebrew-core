class Pcp < Formula
  desc "Performance Co-Pilot is a system performance and analysis framework"
  homepage "https://pcp.io/"
  url "https://dl.bintray.com/pcp/source/pcp-4.1.1.src.tar.gz"
  sha256 "430c3ce05db5e475dc0d962ac584a61a91c69b791e66d5cc684a7aada3e21f52"
  depends_on "pkg-config" => :build
  depends_on "nss"
  depends_on "python"
  depends_on "qt"
  depends_on "readline"
  depends_on "xz"

  def install
    system "./configure", "--prefix=#{prefix}", "CC=clang", "CXX=clang", "--without-manager"
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
    system "#{bin}/pcp", "--version"
  end
end
