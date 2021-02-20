class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.0/isync-1.4.0.tar.gz"
  sha256 "84f8bf3ed293365d6d73702ae4680077efddf641bf1ef63fccbda0589bde785e"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/isync/isync.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "bd536177c4a965daea4358315eb140c0cdda45f4b9cb1477a3ead11ec0ff0e8a"
    sha256 cellar: :any, big_sur:       "4045c90ef0e0471ace0bcd72ed0ca4927efec688005ed0af5811d869b59723b2"
    sha256 cellar: :any, catalina:      "ef6f012a58abcc4efbc4ab2549fe4bf366905afbc7590c842463404e271e2fe6"
    sha256 cellar: :any, mojave:        "f2c706e1acb39bfee2402abb8b36dc0475968c16f97b7c9c92f72ed0bfc6c2f0"
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
