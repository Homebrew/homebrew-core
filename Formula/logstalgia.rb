class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.7/logstalgia-1.0.7.tar.gz"
  sha256 "5553fd03fb7be564538fe56e871eac6e3caf56f40e8abc4602d2553964f8f0e1"
  revision 2

  bottle do
    rebuild 1
    sha256 "d075772d62ab3bfd0816dc0aaa9bfff86277b6d590fabb1e1ede7213f5fc5d80" => :sierra
    sha256 "529e9f890e9fe1dda35ed4318499aa02c2254d05c22d9e4d93f3b08f17539fd9" => :el_capitan
    sha256 "69f55d7dd17d0f601e6ed520f1715402e209ac9bddfda4acb610ad61b1c2c851" => :yosemite
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
