class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.9/logstalgia-1.0.9.tar.gz"
  sha256 "8b66ec1f98c2d6616846aaa693127f9478ddce19e779a224780b0eb1f19819aa"

  bottle do
    sha256 "57cee03375921c5d1cab999a217bfc8dcb551d3f643708d61550a380cc9b22c9" => :high_sierra
    sha256 "f9b7f68acc5ffbb3eadad8510a5a86e7b9883506c30c2866aac8f58636509835" => :sierra
    sha256 "bdfd5eef17767bf73128d3530191c81b1a5345bbf1b6f46341e745c0acda4215" => :el_capitan
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
