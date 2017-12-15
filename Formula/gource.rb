class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.47/gource-0.47.tar.gz"
  sha256 "f2b16083a01b897b6c062b363793028fb9e01cd6f888d91772ee06e56ce398d2"

  bottle do
    sha256 "d42a81092141197cd74f4bbec4e0265c1cbb81a7d00f150dc6cea18319e5b6d2" => :high_sierra
    sha256 "4620f83a4698992da638c4c0b1b02c81ee1e5aecf1e6280a1568043d4af12a2e" => :sierra
    sha256 "bca74b4a29161250c85c39edcb41930fc284abc06024955c759b9c74932a8990" => :el_capitan
    sha256 "8fd44f73f13254c88e52da1c891ebe7d425d426b056764a3142d628519ecff2e" => :yosemite
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on :x11 => :optional

  depends_on "pkg-config" => :build
  depends_on "glm" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{Formula["boost"].opt_prefix}",
                          "--without-x"
    system "make", "install"
  end

  test do
    system "#{bin}/gource", "--help"
  end
end
