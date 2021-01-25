class Mpdscribble < Formula
  desc "Last.fm reporting client for mpd"
  homepage "https://www.musicpd.org/clients/mpdscribble/"
  url "https://www.musicpd.org/download/mpdscribble/0.22/mpdscribble-0.22.tar.gz"
  sha256 "ff882d02bd830bdcbccfe3c3c9b0d32f4f98d9becdb68dc3135f7480465f1e38"
  revision 2

  bottle do
    sha256 "b79e64ee861ea63530317a540dc37222f202a63b59810660b0f94538c16e7334" => :big_sur
    sha256 "e0a631278cb1d14dc4ad63897a68eebd23e5882c4fd9247099d5af1e3e545b4e" => :arm64_big_sur
    sha256 "d8e226d580e44da3f93849bfdd6065a356e9d0e2cf086c31cc4be273e3152980" => :catalina
    sha256 "f6c7e1d2b4f6112ae2b0548e0571580f4f671789e81eb799efc92ac236cd2d0b" => :mojave
    sha256 "68c6dcdc89b8cbdd8b8c5fea0822cfdb883874b390cb5a9a69192880a3b03838" => :high_sierra
    sha256 "bfc893a2fe7e712bfc17f83aeb7e5f9cf46d260f3d5756cd499a6a6100c1feec" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libmpdclient"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      The configuration file was placed in #{etc}/mpdscribble.conf
    EOS
  end

  plist_options manual: "mpdscribble"

  def plist
    <<~EOS
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
