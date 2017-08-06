class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.44/gource-0.44.tar.gz"
  sha256 "2604ca4442305ffdc5bb1a7bac07e223d59c846f93567be067e8dfe2f42f097c"
  revision 1

  bottle do
    rebuild 1
    sha256 "cd48c29bd09e248e4886ac537ca0b3e8323ab57335f559f68e14c9f23c0bb26e" => :sierra
    sha256 "5be79198dd89d0839956997e2847ef077dc89a250742356fb9ec2d7ae0c1e0f2" => :el_capitan
    sha256 "b992780e3865e5a34d2f480343c09c1869c32f00416a214308f9f028c42f61a0" => :yosemite
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
