class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.8.2.tar.bz2"
  sha256 "650ba3e8089624b7ad9e4cc19bc1ac6028edb7523cc111fa1686ea44c0921554"
  revision 1

  bottle do
    cellar :any
    sha256 "1b514bea1dc77be777e0fbd9b972b78fdd9c845ecb718a0d2d0046462b02a2c3" => :high_sierra
    sha256 "e21806f7b1b7cd8def787795a3a976f5bb0de225e52e53dd7371bfff84e78843" => :sierra
    sha256 "0309df060405dedf7f53748a6de92c31fc897526bd77e95b4013dd76f4eb559e" => :el_capitan
  end

  head do
    url "https://github.com/arybczak/ncmpcpp.git"

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
  depends_on "boost"
  depends_on "libmpdclient"
  depends_on "ncurses"
  depends_on "readline"
  depends_on "taglib"
  depends_on "fftw" if build.with? "visualizer"

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
