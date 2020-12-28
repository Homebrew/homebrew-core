class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.1.tar.bz2"
  sha256 "cb814a39c975f5b19c466188433644d1cbdb6db0abe1481d525587b149b36574"
  license "GPL-2.0-or-later"

  head do
    url "https://github.com/ncmpcpp/ncmpcpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    cellar :any
    sha256 "9ef34f21ed819b639f6b6cc0d76bde01be8fcd2d857502bc4997d294d77f08a4" => :big_sur
    sha256 "a836a2912a5929ebf85b66d66e667acfc6ac60cb359b9be965df110068e9485c" => :arm64_big_sur
    sha256 "8e18b43a93c77b2e1539e898cd805bfc87417e485e1698d488aa4927eb34e6f5" => :catalina
    sha256 "d31b7847aa3ac1091882f8dd63f9e5f9c5892c8d9d6bf818dfa6aa428a895db7" => :mojave
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
