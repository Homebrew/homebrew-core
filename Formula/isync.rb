class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.2/isync-1.4.2.tar.gz"
  sha256 "1935e7ed412fd6b5928aaea656f290aa8d3222c5feda31534903934ce4755343"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/isync/isync.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f688e67a5685b88980d6012df7870bffd4b6db77d39edc5a43625992f6b55fff"
    sha256 cellar: :any, big_sur:       "ed5ca308f6e8bee6fbb4bdd145e9bba1c4e0e8ab8eab5ea41e87053add6e0c5e"
    sha256 cellar: :any, catalina:      "e9201a38ab8e0f109897709929eaef91eb184f381024875e35951e6108ffe211"
    sha256 cellar: :any, mojave:        "79b70d1af2227f9142a638f12dfc6986e0cc709241946548546fcaa8cf8cce35"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "berkeley-db"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Regenerated for HEAD, and because of our patch
    if build.head?
      system "./autogen.sh"
    else
      system "autoreconf", "-fiv"
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  plist_options manual: "isync"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>EnvironmentVariables</key>
          <dict>
            <key>PATH</key>
            <string>/usr/bin:/bin:/usr/sbin:/sbin:#{HOMEBREW_PREFIX}/bin</string>
          </dict>
          <key>KeepAlive</key>
          <false/>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/mbsync</string>
            <string>-a</string>
          </array>
          <key>StartInterval</key>
          <integer>300</integer>
          <key>RunAtLoad</key>
          <true />
          <key>StandardErrorPath</key>
          <string>/dev/null</string>
          <key>StandardOutPath</key>
          <string>/dev/null</string>
        </dict>
      </plist>
    EOS
  end

  test do
    system bin/"mbsync-get-cert", "duckduckgo.com:443"
  end
end
