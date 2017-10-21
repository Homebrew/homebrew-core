class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.3.0/isync-1.3.0.tar.gz"
  sha256 "8d5f583976e3119705bdba27fa4fc962e807ff5996f24f354957178ffa697c9c"

  bottle do
    cellar :any
    sha256 "7b7ffd0c838626b698145a205c8325c6c74051c073fc793db724264a5d841dd3" => :high_sierra
    sha256 "646490217fc6569fd0c8999aac9e3b7dfd4ae18aaa20cd0c0b99f0dfd350b4de" => :sierra
    sha256 "060669b949a1d59d8d2432d8c169c4b6af457bde209e670bd0056f4efe9ef0d9" => :el_capitan
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

  def plist; <<~EOS
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
