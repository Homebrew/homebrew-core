class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://mpd.wikia.com/wiki/Client:Mpdscribble"
  url "https://www.musicpd.org/download/mpdscribble/0.22/mpdscribble-0.22.tar.gz"
  sha256 "ff882d02bd830bdcbccfe3c3c9b0d32f4f98d9becdb68dc3135f7480465f1e38"
  revision 1

  bottle do
    sha256 "306e807a9e6169f58968af9f7d6067a03ec632ffe5267150f940fa628e28dfba" => :mojave
    sha256 "0bb89c4d9cac0bd82f40cc7c7907fa150efb1de05ab7da21e7c7d70a6ebb8602" => :high_sierra
    sha256 "0e487444754917082060745ab958e70b1718ea7d1bdd24bc52dbd9823060c114" => :sierra
    sha256 "3dee2dae7ae29bb1a92db5af951740801be7d7204ac6addad6016e8ec07e9fda" => :el_capitan
    sha256 "93d9066107f752b0c18910c5aac8f6f86beaa03cba627fffd6337dda44cf16f9" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def caveats; <<~EOS
    The configuration file was placed in #{etc}/mpdscribble.conf
  EOS
  end

  plist_options :manual => "mpdscribble"

  def plist; <<~EOS
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

  test do
    system "#{bin}/mpdscribble", "--version"
  end
end
