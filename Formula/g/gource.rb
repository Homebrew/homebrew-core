class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.54/gource-0.54.tar.gz"
  sha256 "1dcbcedf65d2cf4d69fe0b633e54c202926c08b829bcad0b73eaf9e29cd6fae5"
  license "GPL-3.0-or-later"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "b8b897102f246e11f945323cef9e073719f726e4d954a43705453fbe26d876f7"
    sha256 arm64_ventura:  "74a2825d26d848ae20da0cc16d771fa7ee1657e61799d1927c018200b7fe4133"
    sha256 arm64_monterey: "7159a6adc1c018d4c7a4fe23365891e87ff7c7729855a9fa89f1a7af947f594c"
    sha256 sonoma:         "4e6ed721e0ee62d188dde9ccb573f0ad5d9880a9d72b8f99661fd2eca8646991"
    sha256 ventura:        "9857f6656f1148210d73fed021d9b09d90570e34170bcaa19dd8808b1548cfd9"
    sha256 monterey:       "e505e8253cfca1d055b4fef25e3376385a19eb89159afb1d1bca5b48e5bf2cbe"
    sha256 x86_64_linux:   "43d9dc33c0bd1148e69b6cbaa5e0b2ec18aaa6ec48f23b32942b5fa04877c6e9"
  end

  head do
    url "https://github.com/acaudwell/Gource.git", branch: "master"

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
  depends_on "pcre2"
  depends_on "sdl2"
  depends_on "sdl2_image"

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx
    ENV.append "LDFLAGS", "-pthread" if OS.linux?

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
