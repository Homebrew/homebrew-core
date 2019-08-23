class Launchdns < Formula
  desc "Mini DNS server designed solely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.4.tar.gz"
  sha256 "60f6010659407e3d148c021c88e1c1ce0924de320e99a5c58b21c8aece3888aa"
  revision 1
  head "https://github.com/josh/launchdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1572081e53a9b2234321ac9f4bb4f48507bbafcd781f29549907e7ded4873526" => :mojave
    sha256 "9379f60efc2a0984c79a3b59dab5093ca3fdaad89a8f697a7623abda15801293" => :high_sierra
    sha256 "ced5d6c6bdb3074c29dd65b244fc4325cc4799820d7dd38c6dedf04c2555f3cb" => :sierra
  end

  depends_on :macos => :yosemite

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix/"etc/resolver/localhost").write("nameserver 127.0.0.1\nport 55353\n")
  end

  plist_options :manual => "launchdns"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/launchdns</string>
          <string>--socket=Listeners</string>
          <string>--timeout=30</string>
        </array>
        <key>Sockets</key>
        <dict>
          <key>Listeners</key>
          <dict>
            <key>SockType</key>
            <string>dgram</string>
            <key>SockNodeName</key>
            <string>127.0.0.1</string>
            <key>SockServiceName</key>
            <string>55353</string>
          </dict>
        </dict>
        <key>StandardErrorPath</key>
        <string>#{var}/log/launchdns.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/launchdns.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    output = shell_output("#{bin}/launchdns --version")
    assert_no_match(/without socket activation/, output)
    system bin/"launchdns", "-p0", "-t1"
  end
end
