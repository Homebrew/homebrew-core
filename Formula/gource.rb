class Gource < Formula
  desc "Version Control Visualization Tool"
  homepage "https://github.com/acaudwell/Gource"
  url "https://github.com/acaudwell/Gource/releases/download/gource-0.51/gource-0.51.tar.gz"
  sha256 "19a3f888b1825aa7ed46f52cebce5012e3c62439e3d281102f21814c7a58e79a"
  license "GPL-3.0"

  bottle do
    sha256 "6db0866cca37c5701a5deb79e4867ec0cf1134c76839a40b6fd49968a5564cb0" => :catalina
    sha256 "18204f0fb8b737d0e903718a645a08d63338c93c7ca8052db569445d19a18800" => :mojave
    sha256 "1dc9d1e848779e59367a2c7714bc6f2c97f2becc3d4ccef8c3576ad38af4053e" => :high_sierra
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
  depends_on "pcre"
  depends_on "sdl2"
  depends_on "sdl2_image"

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
