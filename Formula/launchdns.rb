class Launchdns < Formula
  desc "Mini DNS server designed solely to route queries to localhost"
  homepage "https://github.com/josh/launchdns"
  url "https://github.com/josh/launchdns/archive/v1.0.3.tar.gz"
  sha256 "c34bab9b4f5c0441d76fefb1ee16cb0279ab435e92986021c7d1d18ee408a5dd"
  revision 1
  head "https://github.com/josh/launchdns.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e2a8dcea6e56a04b35be6ac1c1aa740425b621714633681056a1c5447b11eeec" => :mojave
    sha256 "1433f1e56fadabccda5b41a26c69259f5d834d6f6321c2512a9c40eb963f89bd" => :high_sierra
    sha256 "a03349824b4a84565409acc38ec7e2360a96d9de0cc6b3caab1abe0b8b480955" => :sierra
    sha256 "50463d3643f6dda3f4a363ee4efb37fbded8d975ef20cbb49ce0a05a0f26a33f" => :el_capitan
  end

  depends_on :macos => :yosemite

  def install
    ENV["PREFIX"] = prefix
    system "./configure", "--with-launch-h", "--with-launch-h-activate-socket"
    system "make", "install"

    (prefix/"etc/resolver/localhost").write("nameserver 127.0.0.1\nport 55353\n")
  end

  def caveats; <<~EOS
    To have *.localhost resolved to 127.0.0.1:
      sudo ln -s #{HOMEBREW_PREFIX}/etc/resolver /etc
  EOS
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
