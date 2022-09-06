class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.53/gource-0.53.tar.gz"
  sha256 "3d5f64c1c6812f644c320cbc9a9858df97bc6036fc1e5f603ca46b15b8dd7237"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "efa5c9ef2d78af44422171df97d6cb513ce8f4dfd6d236aeb3089fa8029ae89c"
    sha256 arm64_big_sur:  "6ab4d722ac6dc2984eada4861674da1e681efc254c68a3f2fd82128813d4143d"
    sha256 monterey:       "df637390566e28ce1054679690e6ee027a830d560b08fcceae6195a8a7acfb94"
    sha256 big_sur:        "26927a451639add4b2b7617af818d8c045ccb619e0c8e04905b8be08857a754d"
    sha256 catalina:       "a7ef7bd6622ed0a142850b90406f94d08c5c39c58b4fb2d87c0d2f60423158fc"
    sha256 x86_64_linux:   "2f151752f275c4431bb0719f92697a821427c5e666856fc18c5048567f8bab16"
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
