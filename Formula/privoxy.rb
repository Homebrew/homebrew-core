class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.24%20%28stable%29/privoxy-3.0.24-stable-src.tar.gz"
  sha256 "a381f6dc78f08de0d4a2342d47a5949a6608073ada34b933137184f3ca9fb012"

  bottle do
    cellar :any
    revision 1
    sha256 "574b1d90ef7af5383395176ca64a025f2a3fab360f0fb901b01925a05115194d" => :el_capitan
    sha256 "860b086ac747488838dbc9596749d4e422dc0a6f59db087325f614db81eb888e" => :yosemite
    sha256 "0f166b0be44a2bc324e9888598acc9173dcf8beb2fe1dac42955ea2c63732a2a" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    # Find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  plist_options :manual => "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/privoxy</string>
        <string>--no-daemon</string>
        <string>#{etc}/privoxy/config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
