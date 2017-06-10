class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.2.1/isync-1.2.1.tar.gz"
  sha256 "e716de28c9a08e624a035caae3902fcf3b511553be5d61517a133e03aa3532ae"

  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "76ed1f0a0d407d27870f7beb51c38275e6034b1c3c74ee0f3628e08fdadf6607" => :sierra
    sha256 "38fb0d21a245178886acb1262f57ddde284adbf889039baf3401bf2028d7cba7" => :el_capitan
    sha256 "074b9295e7ac9773eafac5bdc20e32d42d8023ffccd275235d0cb72ff09574cf" => :yosemite
    sha256 "147097d617448be4d6796bf189a05200c1afd738ad64fe05aa40c61db10b5194" => :mavericks
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
    system bin/"get-cert", "duckduckgo.com:443"
  end
end
