class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v5/nano-5.7.tar.xz"
  sha256 "d4b181cc2ec11def3711b4649e34f2be7a668e70ab506860514031d069cccafa"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "ddbca2f67a7e98eed849c6ee2f0d818f89e9b5a4e8a34e5ed9fef8a86d508a8c"
    sha256 big_sur:       "23f59d57b904ceba9f709fa3fb25c18891d9a6091e8fd411a8a6a3b84a138955"
    sha256 catalina:      "12483c78e4b66e8fa3b5c9983acf73aa162d6004dacf027823a22a362d9e8210"
    sha256 mojave:        "1f76378ae998b1541c336611a0e1064d98a7028c407f46a0f4e00547fe98ad1a"
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "ncurses"

  on_linux do
    depends_on "libmagic"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--enable-color",
                          "--enable-extra",
                          "--enable-multibuffer",
                          "--enable-nanorc",
                          "--enable-utf8"
    system "make", "install"
    doc.install "doc/sample.nanorc"
  end

  test do
    system "#{bin}/nano", "--version"
  end
end
