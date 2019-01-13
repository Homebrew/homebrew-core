class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.8.2.tar.bz2"
  sha256 "650ba3e8089624b7ad9e4cc19bc1ac6028edb7523cc111fa1686ea44c0921554"
  revision 3

  bottle do
    cellar :any
    sha256 "0d4286d5cdaf685881ad2e2036ce8f80280f5a11b36a5c8e187c27ae992ff818" => :mojave
    sha256 "993e5deb4d11ab51d027498935f378634cbeed7d191000d0ad7faf4452e86e6c" => :high_sierra
    sha256 "1eb68dafbf672eb99e947a8e40b1ae49aa1d4c0d2e128d45f94d6fe7ab9a67ba" => :sierra
  end

  head do
    url "https://github.com/arybczak/ncmpcpp.git"

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

  needs :cxx11

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
