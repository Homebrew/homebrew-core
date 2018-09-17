class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.49/gource-0.49.tar.gz"
  sha256 "a9dd23693861e224322708a8e26c9e3aaa3e4c9ec41264b1ee2d5dcd6e2c0e8a"

  bottle do
    sha256 "6efd53e0c1ceb57a85f9083d69303b8b01ff648be422f3a6cccf9f7eba1eef5f" => :mojave
    sha256 "d207627927335768487a9da97c079f462894657d780ab983a28617084f66cf8b" => :high_sierra
    sha256 "1c51103eec9b5bc824534c9f90fa8711718f793a3b91646c3da97e24acc5a5b1" => :sierra
    sha256 "20859d4ec9642ebb2b4d9a141d21029038dcef38c6955d3b7c03d044f76d0682" => :el_capitan
  end

  head do
    url "https://github.com/acaudwell/Gource.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on :x11 => :optional

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
