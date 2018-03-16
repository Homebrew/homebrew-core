class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.48/gource-0.48.tar.gz"
  sha256 "b7055347dad152125ab83e121e3fcaf8cf79bc5bcaec295e4ed9475c40651d13"

  bottle do
    sha256 "7b0c15ecae8a96764432271dc0b79ae68bdfd365a0e90481535d27978571175e" => :high_sierra
    sha256 "63725d87fdd28ac168a8e79f0cba780c7c15f284cc904d8aaab8dac63179254b" => :sierra
    sha256 "9fc979ecfa0723d8fb3462e8a9206b88109bcd2252e7696effb5035b4564a408" => :el_capitan
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
  depends_on "boost"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

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
