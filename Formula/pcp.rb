class Pcp < Formula
  desc "Performance Co-Pilot is a system performance and analysis framework"
  homepage "https://pcp.io/"
  url "https://dl.bintray.com/pcp/source/pcp-4.1.3.src.tar.gz"
  sha256 "ca593d65ccaf6f481d55720019e317679afeadd589aa37c878ec1e8629a1e75c"

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
    system "/usr/local/Cellar/pcp/4.1.1/etc/init.d/pmcd", "start"
  end
end
