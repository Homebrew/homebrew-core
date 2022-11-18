class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.53/gource-0.53.tar.gz"
  sha256 "3d5f64c1c6812f644c320cbc9a9858df97bc6036fc1e5f603ca46b15b8dd7237"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_ventura:  "557adabdc455f36a53771b2dfdc4d105011de331d4592fc73225a5f0c34890bb"
    sha256 arm64_monterey: "39002ff5443571242c6dcf76728a068954bb534fe5c479412cfabc7dcdff1efe"
    sha256 arm64_big_sur:  "54cca753a7f2705de77c771c0671027f3ba8eb57f3cca6047ba3f380921c0052"
    sha256 ventura:        "f1951fd9ec911b7f608e4bc647a076ccda57a0aa21a81325d2e3f897969f43ec"
    sha256 monterey:       "10a8655e6e61846e5ccac81e19aa9b26382092c64035a74ca1aa29a4e3c8c046"
    sha256 big_sur:        "bbdf8ef1bf9bc91e47309ca0f30f81906ebb5776ebdb1c1e95c73789358bf9fe"
    sha256 catalina:       "95f4d567f33ae6015a996256ee9ccd3e520644d6da2f3b8d61f79787b7199203"
    sha256 x86_64_linux:   "b749ae045d6147ee4cc93068c62729f98ef5154e63735bd70561cbdb198b1e23"
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
