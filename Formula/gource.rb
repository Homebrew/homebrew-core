class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.44/gource-0.44.tar.gz"
  sha256 "2604ca4442305ffdc5bb1a7bac07e223d59c846f93567be067e8dfe2f42f097c"
  revision 1

  bottle do
    sha256 "9c6057428b6dd98496945154745c8611fb9cf5c335b0f22f2e8cc32ccb5f962e" => :sierra
    sha256 "ee89e0c61f22e4852be9fec59bac8419e962279515f7fbfb42b3ba4faf6365e8" => :el_capitan
    sha256 "24e685a6ddefbe40c6ca01f9207b6e5b5541cabae7660c42d4ec8b795d5d2941" => :yosemite
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
