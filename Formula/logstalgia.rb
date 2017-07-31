class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.7/logstalgia-1.0.7.tar.gz"
  sha256 "5553fd03fb7be564538fe56e871eac6e3caf56f40e8abc4602d2553964f8f0e1"
  revision 2

  bottle do
    sha256 "07a224c6269166f3a5d997a2ed6b66383c3f6751a40a9eb0953ec5f77865eaed" => :sierra
    sha256 "a5c3faad0786b636fa87a5c60aaf097ab3cf8ae7c1aefe4410e78fdaa837255e" => :el_capitan
    sha256 "8426a074b0331fd5d2a3e2c0036973e771890fb84169020167ff518d0d49880b" => :yosemite
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
  depends_on "jpeg"
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
