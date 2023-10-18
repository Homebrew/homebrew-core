class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.54/gource-0.54.tar.gz"
  sha256 "1dcbcedf65d2cf4d69fe0b633e54c202926c08b829bcad0b73eaf9e29cd6fae5"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_sonoma:   "12890c4d132262201c394013213294907bbdd62b923533dff002358e90b801f6"
    sha256 arm64_ventura:  "55bde6411130890bdfd748a794b146b1f51a124d52f696031b5cae73f0348128"
    sha256 arm64_monterey: "cd48f104b8543646206b889ff287c33ccc9d39a7abf422ecb910d90c7735ff46"
    sha256 arm64_big_sur:  "3d44bb4efa40c8a38a56ef8353eae092ecbe0be9ba248a3f0eda8f20369c594f"
    sha256 sonoma:         "a449d158676fd844b1f0efa5cac72bfe9880a76dd86f19b655605e35ec11117d"
    sha256 ventura:        "acfa227bd1a271c427baf0ea8f632f4a3feaf4d5deec4857e45282f0014443bc"
    sha256 monterey:       "9dac8b441b10030e29c92bb397b7a0063dfeefdf28280bd97b30316d809e8a9f"
    sha256 big_sur:        "44e965db2b905de18031741315ce5554b048c77510be2611164700dbf6b4601f"
    sha256 x86_64_linux:   "f8bd7eb81779073d48607fbdbf475eaa4fbe6abcc541da7931c8d8a21031c44e"
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
