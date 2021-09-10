class Isync < Formula
  desc "Synchronize a maildir with an IMAP server"
  homepage "https://isync.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/isync/isync/1.4.3/isync-1.4.3.tar.gz"
  sha256 "b4c720745bda3447fbd5b9f71783b23f699a55295917ae7586ee5c22e91b9708"
  license "GPL-2.0"
  head "https://git.code.sf.net/p/isync/isync.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "234460b3dd4674da6104722ae8590a73c67ba595af54e66d2ddaeae54efd4be9"
    sha256 cellar: :any,                 big_sur:       "908d620917e954c55c095b015f4f13475d1ec69022951fc06154a193c6b368b1"
    sha256 cellar: :any,                 catalina:      "c8c78c50bf5d9070cbd3faaf43555e68bf0c673cb17bd25034ea4e93400f882e"
    sha256 cellar: :any,                 mojave:        "8e24cd012a3640bf0aaccf003a1682285def1e05580fe70292d2765befb52e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0acc76de8df5cea3da8ac0e6a005b616946ab1ac19d91e09670e19b9fdf7ebe"
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
