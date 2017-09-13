class Enigma < Formula
  desc "Puzzle game inspired by Oxyd and Rock'n'Roll"
  homepage "http://www.nongnu.org/enigma/"
  url "https://downloads.sourceforge.net/project/enigma-game/Release%201.21/enigma-1.21.tar.gz"
  sha256 "d872cf067d8eb560d3bb1cb17245814bc56ac3953ae1f12e2229c8eb6f82ce01"
  revision 1

  bottle do
    sha256 "5ba45be931b9299227ad05850080a1409e5695655958b77aaf379d32e789fef2" => :sierra
    sha256 "32ee5ea2d062e859e76924184e10b43dc8530023884c517186a2572419ca844f" => :el_capitan
    sha256 "d71f474a79bc613cf655a07433d0c559607037a2f872caf31960d2aa714d618a" => :yosemite
  end

  head do
    url "https://github.com/Enigma-Game/Enigma.git"
    depends_on "texi2html" => :build
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "imagemagick" => :build
  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer" => "with-libmikmod"
  depends_on "sdl_ttf"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "xerces-c"
  depends_on "gettext"
  depends_on "enet"

  def install
    system "./autogen.sh" if build.head?

    inreplace "configure" do |s|
      s.gsub! /-framework (SDL(_(mixer|image|ttf))?)/, '-l\1'
      s.gsub! %r{\${\w+//\\"/}/lib(freetype|png|xerces-c)\.a}, '-l\1'
      s.gsub! %r{(LIBINTL)="\${with_libintl_prefix}/lib/lib(intl)\.a"}, '\1=-l\2'
      s.gsub! /^\s+LIBENET_CFLAGS\n.*LIBENET.*\n\s+LIBENET_LIBS\n.*LIBENET.*$/, ""
    end
    inreplace "src/Makefile.in" do |s|
      s.gsub! %r{(cp -a /Library/Frameworks/.*)$}, 'echo \1'
      s.gsub! "mkalias -r", "ln -s"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libintl-prefix=#{Formula["gettext"].opt_prefix}",
                          "--with-system-enet"
    system "make"
    system "make", "macapp"
    prefix.install "etc/macfiles/Enigma.app"
    bin.write_exec_script "#{prefix}/Enigma.app/Contents/MacOS/enigma"
  end

  test do
    assert_equal "Enigma v#{version}", shell_output("#{bin}/enigma --version").chomp
  end
end
