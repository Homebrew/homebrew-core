class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.1.tar.bz2"
  sha256 "cb814a39c975f5b19c466188433644d1cbdb6db0abe1481d525587b149b36574"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "5dc897a1e5609e9a46e9bc444c1fab689a20f92f8db254639f8d591b4a7ece89" => :big_sur
    sha256 "72834162ce65387eee7f43092fb5bf0a911f1e73f3d3a9270236eb579b25b2a2" => :arm64_big_sur
    sha256 "51f1772590e52afb0cc694b1773485172acb6274cd94940b7619a8a1d551722d" => :catalina
    sha256 "e33302683bf707411abc1b98fef60487df7917f8ece2d278688dfacf0346da41" => :mojave
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
