class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://ncmpcpp.rybczak.net/stable/ncmpcpp-0.7.4.tar.bz2"
  sha256 "d70425f1dfab074a12a206ddd8f37f663bce2bbdc0a20f7ecf290ebe051f1e63"
  revision 2

  bottle do
    cellar :any
    sha256 "23f55a03c6d95a8ae7de5cf915d301146175e1d75dcc626193c6615f00b1c614" => :sierra
    sha256 "8b6bd9148dee65aeb28cdf1658339cf59042ca7b410d361b8c3ed09cbf53dc59" => :el_capitan
    sha256 "5ba52a24064d47a7518d077d87025161c836d998e4e0511c45c1cbe4dc3cc94f" => :yosemite
  end

  head do
    url "git://repo.or.cz/ncmpcpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  deprecated_option "outputs" => "with-outputs"
  deprecated_option "visualizer" => "with-visualizer"
  deprecated_option "clock" => "with-clock"

  option "with-outputs", "Compile with mpd outputs control"
  option "with-visualizer", "Compile with built-in visualizer"
  option "with-clock", "Compile with optional clock tab"

  depends_on "pkg-config" => :build
  depends_on "libmpdclient"
  depends_on "readline"
  depends_on "fftw" if build.with? "visualizer"

  if MacOS.version < :mavericks
    depends_on "boost" => "c++11"
    depends_on "taglib" => "c++11"
  else
    depends_on "boost"
    depends_on "taglib"
  end

  needs :cxx11

  def install
    ENV.cxx11
    ENV.append "LDFLAGS", "-liconv"
    ENV.append "BOOST_LIB_SUFFIX", "-mt"
    ENV.append "CXXFLAGS", "-D_XOPEN_SOURCE_EXTENDED"

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--with-taglib",
      "--with-curl",
      "--enable-unicode",
    ]

    args << "--enable-outputs" if build.with? "outputs"
    args << "--enable-visualizer" if build.with? "visualizer"
    args << "--enable-clock" if build.with? "clock"

    if build.head?
      # Also runs configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ncmpcpp --version")
  end
end
