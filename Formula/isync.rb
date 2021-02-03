class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.3.3/isync-1.3.3.tar.gz"
  sha256 "f2213bf7f90266e1295deafe39b02d1ba0b4c7f3b897c09cd17c60f0d4f4c882"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/isync/isync.git"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "9d2c437a42156cc9d7589b27fb1f84db292d76482bf103b725c89898c9405a2c"
    sha256 cellar: :any, big_sur:       "278f8ee2e2d3cd15cff66ab586f458b2103896573e2772522d97629c46768e37"
    sha256 cellar: :any, catalina:      "e246ae47ad32253be95b4344e3a8c7ef2b586364944080d98beb7d9543ba7c9e"
    sha256 cellar: :any, mojave:        "af52bcdb59df55a0aa754d5fd3b77ef14107365d9d1ef39cf20115e0d49d6221"
    sha256 cellar: :any, high_sierra:   "aaea9bd9e79853387aef7c312616d9c1446af6661b889539500e5640070679f4"
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
