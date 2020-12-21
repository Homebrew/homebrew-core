class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.9.tar.bz2"
  sha256 "4148687f481b8eb016aa5889f74b4ae8871920d46c0a6c004a9ede140d2f1667"
  license "GPL-2.0-or-later"

  bottle do
    cellar :any
    sha256 "8e20eaa820748ed300d4d14923c3cca4b5449589618d0ee277e67e55c32bcc28" => :big_sur
    sha256 "0aa6ab305f259cff180c27baaf19c43dc4f71a6b4ddc6f367847c2f7299d72a3" => :catalina
    sha256 "5e750b7427b834e44ad31e649998d7cc7e8cd6f005e122c835c5333180064957" => :mojave
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
