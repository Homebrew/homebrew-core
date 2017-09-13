class Libbluray < Formula
  desc "Blu-Ray disc playback library for media players like VLC"
  homepage "https://www.videolan.org/developers/libbluray.html"
  url "https://download.videolan.org/pub/videolan/libbluray/1.0.1/libbluray-1.0.1.tar.bz2"
  sha256 "0f9f9a1db2f48cafc70ed2596ff3594b597e2027408f5f2be6191c245d67853a"

  bottle do
    cellar :any
    sha256 "027cc70d3f1d213fb2fc94c7ee11fa68e14da49c5028276a0ada242cc16da37a" => :sierra
    sha256 "a34fd7a55a8a5322a2e389889c9ec9c9e39638c59c9bb1ecfc22d2e7fa9c1298" => :el_capitan
    sha256 "967f6e43aa8e1be447a837d3eee4dd7d4542918ca375b0d1d14b6fa2dafa7c94" => :yosemite
  end

  head do
    url "https://git.videolan.org/git/libbluray.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "ant" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype" => :recommended

  def install
    # https://mailman.videolan.org/pipermail/libbluray-devel/2014-April/001401.html
    ENV.append_to_cflags "-D_DARWIN_C_SOURCE"

    args = %W[--prefix=#{prefix} --disable-dependency-tracking]
    args << "--without-freetype" if build.without? "freetype"

    system "./bootstrap" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
