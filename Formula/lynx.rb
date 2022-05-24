class Lynx < Formula
  desc "Text-based web browser"
  homepage "https://invisible-island.net/lynx/"
  url "https://invisible-mirror.net/archives/lynx/tarballs/lynx2.8.9rel.1.tar.bz2"
  version "2.8.9rel.1"
  sha256 "387f193d7792f9cfada14c60b0e5c0bff18f227d9257a39483e14fa1aaf79595"
  license "GPL-2.0"
  revision 1

  livecheck do
    url "https://invisible-mirror.net/archives/lynx/tarballs/?C=M&O=D"
    regex(/href=.*?lynx[._-]?v?(\d+(?:\.\d+)+(?:rel\.?\d+))\.t/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_monterey: "521f6b88727a5d059be6dbdb3b4ab121a75685a069d637a2392aa9495be12ff5"
    sha256 arm64_big_sur:  "97f8541d87999f6f75c7283b276b72b90d142abe1fbec9d5d475183a755549d9"
    sha256 monterey:       "f57f89264c25fae795e80a505995f9e6a57d6bb575611abdd41ca0a886f9ebec"
    sha256 big_sur:        "20ce6341dccfd5e1aa40ec6c29fa8954ecaab80cefad190525adece0f3355860"
    sha256 catalina:       "7a726cbbb56d51acd300ac36cf338862ffd64f07aaef97cbab9c519c47204230"
    sha256 x86_64_linux:   "9705dd1b53a269e2ccd2926928f499a4116385d86edbe9bb4ba9e4517dde104f"
  end

  depends_on "openssl@1.1"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Using --with-screen=ncurses to due to behaviour change in Big Sur
    # https://github.com/Homebrew/homebrew-core/pull/58019

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-echo",
                          "--enable-default-colors",
                          "--with-zlib",
                          "--with-bzlib",
                          "--with-ssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--enable-ipv6",
                          "--with-screen=ncurses",
                          "--enable-externs",
                          "--disable-config-info"
    system "make", "install"
  end

  test do
    system "#{bin}/lynx", "-dump", "https://example.org/"
  end
end
