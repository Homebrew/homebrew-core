class Nano < Formula
  desc "Free (GNU) replacement for the Pico text editor"
  homepage "https://www.nano-editor.org/"
  url "https://www.nano-editor.org/dist/v7/nano-7.2.tar.xz"
  sha256 "86f3442768bd2873cec693f83cdf80b4b444ad3cc14760b74361474fc87a4526"
  license "GPL-3.0-or-later"

  livecheck do
    url "https://www.nano-editor.org/download.php"
    regex(/href=.*?nano[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c202cf2b6b1251f0caed55ffa083f71e6b63d17d0c9dd3d3673b133b85cc5e79"
    sha256 arm64_monterey: "b96c11037d0cb45f726a3ac0f02f9312d6327217781dbeabaf6f28fd25b1cae2"
    sha256 arm64_big_sur:  "cf1620dade11f6ecac23c16ea62ce40db48bc4583b6d0312c35585488e29d273"
    sha256 ventura:        "6e81fda89fd4f2acc937a596b5a52eac88ba497f2a15ed73c66f898edd39f411"
    sha256 monterey:       "7efca387c11b43f3342593b170c7a5b843780fe41b9831b09b600603d84ce0d2"
    sha256 big_sur:        "050af59bf8fc46e40ad25566756c0aee526603e86f03da49e2d48239707ac452"
    sha256 x86_64_linux:   "eb541e3efe8242f2b5d758e2c0c3467f0b2bf4cc8d992b31ce72f2c0e99f0022"
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
