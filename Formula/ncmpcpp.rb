class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.8.2.tar.bz2"
  sha256 "650ba3e8089624b7ad9e4cc19bc1ac6028edb7523cc111fa1686ea44c0921554"
  license "GPL-2.0"
  revision 11

  bottle do
    cellar :any
    sha256 "db9ad1bc5d6e88b167abc341b4d8aa3528a79311f4f53ce3b73baabc649e2182" => :catalina
    sha256 "e701adbdc62fd5059d7671279928ea4ace0e42d489899a409ae1f1914a38b68e" => :mojave
    sha256 "5bc263041e6cba45e161a4f5efebc87598a0721b2103fd71a34abe252b92a98c" => :high_sierra
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
