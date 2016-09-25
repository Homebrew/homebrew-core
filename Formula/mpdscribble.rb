class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://mpd.wikia.com/wiki/Client:Mpdscribble"
  url "https://www.musicpd.org/download/mpdscribble/0.22/mpdscribble-0.22.tar.gz"
  sha256 "ff882d02bd830bdcbccfe3c3c9b0d32f4f98d9becdb68dc3135f7480465f1e38"

  bottle do
    cellar :any
    rebuild 1
    sha256 "4d75fda4d103bb09de6589f423a5bcae350b36710c632a4c9d26a2cc4adb31fe" => :sierra
    sha256 "68462d65b9b5e81582b923ee81ae6f02f8260d33cba36b2507d132d8ca39783e" => :el_capitan
    sha256 "1b42dbee7ea325f3a5bd3de346ecfa9904dd5bcf65a68e10ee6f34d5065001c3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    The configuration file was placed in #{etc}/mpdscribble.conf
    EOS
  end

  plist_options :manual => "mpdscribble"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/mpdscribble</string>
            <string>--no-daemon</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
    </dict>
    </plist>
    EOS
  end
end
