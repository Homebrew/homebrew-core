class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.47/gource-0.47.tar.gz"
  sha256 "f2b16083a01b897b6c062b363793028fb9e01cd6f888d91772ee06e56ce398d2"

  bottle do
    sha256 "315049c4c3c32f00ae3f334ee67ff0621c9b68f748fc73e63eea49f8e28c853c" => :sierra
    sha256 "0407757d9bc3fc79a61356421338954b1c2a2661f5f0e0c5572da164f9a024df" => :el_capitan
    sha256 "b0db447b92392ef7be2a54ca1697e5aea728b7865d15b37c04ff2c481b208b45" => :yosemite
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
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  # boost failing on lion
  depends_on :macos => :mountain_lion

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
  else
    depends_on "boost"
  end

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
