class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.3.0/isync-1.3.0.tar.gz"
  sha256 "8d5f583976e3119705bdba27fa4fc962e807ff5996f24f354957178ffa697c9c"

  bottle do
    cellar :any
    sha256 "c214c8858ffe49a7598fdc52ee0c63e981adcd2e3b6c24e61caae5c909ade755" => :high_sierra
    sha256 "ae610fd466221c43e21699d087cd1b63808845782c0420b53d56bf895b6a4b53" => :sierra
    sha256 "c7fb30472091072e7e461913ed0aacf2b5653c60c4daae86db5ca13614bae4f5" => :el_capitan
    sha256 "264399ce5b39f9b5f67d5d528e509c870dd0588569d5f2f0964f401c9813969f" => :yosemite
  end

  head do
    url "https://git.code.sf.net/p/isync/isync.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "openssl"
  depends_on "berkeley-db" => :optional

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-silent-rules
    ]
    args << "ac_cv_berkdb4=no" if build.without? "berkeley-db"

    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "isync"

  def plist; <<-EOS.undent
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
          <string>Periodic</string>
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
