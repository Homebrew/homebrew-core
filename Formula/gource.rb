class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.43/gource-0.43.tar.gz"
  sha256 "85a40ac8e4f5c277764216465c248d6b76589ceac012541c4cc03883a24abde4"
  revision 4

  bottle do
    sha256 "5f14aa304ad565f46c50b40133bb4bb852ac6be34308c0cc863ec0a3e35e9d8e" => :el_capitan
    sha256 "97e4de948f698169acc304f66e4c3297e42c7b8a805906b888b782c30df1de2c" => :yosemite
    sha256 "e1baaf49b72ab9e8f4c6ab4918fc851b305a2458d3894eee79e923c51e65c142" => :mavericks
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
