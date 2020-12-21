class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.tar.bz2"
  sha256 "4148687f481b8eb016aa5889f74b4ae8871920d46c0a6c004a9ede140d2f1667"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "f6720638a422628e6902d967836d3ee5afbcf60ad6fa8bca5e8e01fcf91d5113" => :big_sur
    sha256 "27e9bf5f1d45960238c2fe17686ae0619f9cafd9a84d49dbeee7b89b92d31087" => :catalina
    sha256 "e496faaff1d7e7b9ef1e2bde5e47b49c2f52af6f422c908dc8d1b9948ccf015a" => :mojave
  end

  head do
    url "https://github.com/ncmpcpp/ncmpcpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "fftw"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-clock
      --enable-outputs
      --enable-unicode
      --enable-visualizer
      --with-curl
      --with-taglib
    ]

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    ENV.delete("LC_CTYPE")
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
