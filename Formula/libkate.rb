class Libkate < Formula
  desc "Overlay codec for multiplexed audio/video in Ogg"
  homepage "https://code.google.com/archive/p/libkate/"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/libkate/libkate-0.4.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/libk/libkate/libkate_0.4.1.orig.tar.gz"
  sha256 "c40e81d5866c3d4bf744e76ce0068d8f388f0e25f7e258ce0c8e76d7adc87b68"
  revision 1

  bottle do
    revision 2
    sha256 "5fcb9aa4ebc30da75238c93bcdde964cc47e48a33363e3d2d0d9f75e4c42335e" => :el_capitan
    sha256 "28c10dfb283d2396e16da62f758be0e68ea0494285cccd29fe0468ee532b57db" => :yosemite
    sha256 "82c09456664ea36ddff9bf368c658c662a1dd356f7a742dcf6670a89c793d68d" => :mavericks
    sha256 "d54d60d1803d08abf706e0ac0bd699b30ec90031cc52e56da07fd8ee3246a855" => :mountain_lion
  end

  option "with-docs", "Build documentation"
  option "with-examples", "Build example streams"

  depends_on "pkg-config" => :build
  depends_on "doxygen" => :build if build.with? "docs"
  depends_on "oggz" if build.with? "examples"
  depends_on "libpng"
  depends_on "libogg"
  depends_on "wxmac" => :optional

  fails_with :gcc do
    build 5666
    cause "Segfault during compilation"
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--enable-static",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"katedec", "-V"
  end
end
