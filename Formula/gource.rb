class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.44/gource-0.44.tar.gz"
  sha256 "2604ca4442305ffdc5bb1a7bac07e223d59c846f93567be067e8dfe2f42f097c"
  revision 1

  bottle do
    sha256 "b5cd5eb88c4f72c95672a82f28c540ce52e80ea491aee023640acc3fc5585139" => :sierra
    sha256 "5870be68c62621907fb0f3f04dfc0f93cf9c99f12d715e36a85cbd8fcd6abd0e" => :el_capitan
    sha256 "35ce40b076a186bceadd909edc82ce007d83372ed65832c473ea91174dd077b7" => :yosemite
    sha256 "1f33484c86e75e1be2ba4447f19c98645f5483119c4dba101e76213b425746ab" => :mavericks
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
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

  # boost failing on lion
  depends_on :macos => :mountain_lion

  if MacOS.version < :mavericks
    depends_on "boost@1.61" => "c++11"
  else
    depends_on "boost@1.61"
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
