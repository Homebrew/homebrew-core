class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.8.2.tar.bz2"
  sha256 "650ba3e8089624b7ad9e4cc19bc1ac6028edb7523cc111fa1686ea44c0921554"
  revision 10

  bottle do
    cellar :any
    sha256 "2194f735d702969961d245df70337a8bdce79810e21a59f3a18c35b0b521536f" => :catalina
    sha256 "c26a91179762bb19c46d63e0cda3eeedb994160fb1487fdd20ddbcd099173d82" => :mojave
    sha256 "e71331e4fca11c3a4f9089f88f851463046e14e3956741e27af25ebb5c60d273" => :high_sierra
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
