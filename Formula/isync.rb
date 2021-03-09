class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.1/isync-1.4.1.tar.gz"
  sha256 "0d36dbb57bb06c8bbe10bb66f40ae543095b143443209b7037167be600420150"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/isync/isync.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "47e57e76845e8f327c3125d97a80695e1f55b2f92837a9f6d9d3e496cbb84345"
    sha256 cellar: :any, big_sur:       "5d051373932508e94d32d663a4f5352213997b107b690b702383a51810dad7a0"
    sha256 cellar: :any, catalina:      "25182d348d0169c13d02405319edb4c764e421af445ca9cd903ea1a6964fcf4d"
    sha256 cellar: :any, mojave:        "2d7e9567b746d9aaed7ec0e704800180b448df8ae762636182800eba491dad31"
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
