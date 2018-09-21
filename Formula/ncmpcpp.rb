class Ncmpcpp < Formula
  desc "Ncurses-based client for the Music Player Daemon"
  homepage "https://rybczak.net/ncmpcpp/"
  url "https://rybczak.net/ncmpcpp/stable/ncmpcpp-0.8.2.tar.bz2"
  sha256 "650ba3e8089624b7ad9e4cc19bc1ac6028edb7523cc111fa1686ea44c0921554"
  revision 1

  bottle do
    cellar :any
    sha256 "bdda3cff6eee0d982d5a9b3a8fbac647d333a36dab2471c5af502b1c0482be2c" => :mojave
    sha256 "0d0f6753db53a1244b735d337511549feb336a1d616b11dec253cfffa80d060d" => :high_sierra
    sha256 "862b17bef067d8ad9467aff89e1fddd18f2128daed8b8ac4cf53bb7ded9d85bb" => :sierra
    sha256 "f55716214e49a713a0a9c5c341750d34ad8f3f47b16cc76e235c8d7dc8a72c01" => :el_capitan
  end

  head do
    url "https://github.com/arybczak/ncmpcpp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-outputs", "Compile with mpd outputs control"
  option "with-visualizer", "Compile with built-in visualizer"
  option "with-clock", "Compile with optional clock tab"

  deprecated_option "outputs" => "with-outputs"
  deprecated_option "visualizer" => "with-visualizer"
  deprecated_option "clock" => "with-clock"

  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "fftw" if build.with? "visualizer"
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
