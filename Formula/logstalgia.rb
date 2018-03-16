class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.1.1/logstalgia-1.1.1.tar.gz"
  sha256 "d693e432511d8de792ebe04cfb495fdcd38510641b4cd5f9b72f8a9a309a765b"

  bottle do
    sha256 "e2be7c6d44bb1abb4ff78afa540a0c874b3a0875c4135abb12a4537ffeb0ae16" => :high_sierra
    sha256 "2d6564479e750420eeb411aa0a616ed9cf124744df82f7db2cb131cafa5ff9cb" => :sierra
    sha256 "d50b766fb0b9ef5eafea93bf1e0640ce5de6f9456e3576ed46be7dd4e1bd8f2f" => :el_capitan
  end

  head do
    url "https://github.com/acaudwell/Logstalgia.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost" => :build
  depends_on "glm" => :build
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "freetype"
  depends_on "glew"
  depends_on "libpng"
  depends_on "pcre"

  needs :cxx11

  def install
    # clang on Mt. Lion will try to build against libstdc++,
    # despite -std=gnu++0x
    ENV.libcxx

    # For non-/usr/local installs
    ENV.append "CXXFLAGS", "-I#{HOMEBREW_PREFIX}/include"

    # Handle building head.
    system "autoreconf", "-f", "-i" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--without-x"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "Logstalgia v1.", shell_output("#{bin}/logstalgia --help")
  end
end
