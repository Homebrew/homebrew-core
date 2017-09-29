class Logstalgia < Formula
  desc "Web server access log visualizer with retro style"
  homepage "http://logstalgia.io/"
  url "https://github.com/acaudwell/Logstalgia/releases/download/logstalgia-1.0.8/logstalgia-1.0.8.tar.gz"
  sha256 "32e05fc601d48993749665e47d553ae8ab2190c7ec5350c1fe562fcf9638388a"

  bottle do
    rebuild 1
    sha256 "e3c15e1e7c682bc3a186202a6f868b396371d7f4517c25574329ecd3ccb95cf4" => :high_sierra
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
