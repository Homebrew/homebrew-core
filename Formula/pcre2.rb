class Pcre2 < Formula
  desc "Perl compatible regular expressions library with a new API"
  homepage "http://www.pcre.org/"
  url "https://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre2-10.23.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.exim.org/pub/pcre/pcre2-10.23.tar.bz2"
  sha256 "dfc79b918771f02d33968bd34a749ad7487fa1014aeb787fad29dd392b78c56e"
  head "svn://vcs.exim.org/pcre2/code/trunk"

  bottle do
    cellar :any
    sha256 "713086fd17e6d5543cc0144e3055ee0382dc1b092eb9fafdbda73a7b2539c363" => :sierra
    sha256 "151ff71a40f5b960c7504b77e0d5c18d8873a201c725c6b6d357f559a50722dd" => :el_capitan
    sha256 "18f0559c760d65f0f2323499fcf306c04576b3630a46d61a3582a37fb103bf29" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-pcre2-16",
                          "--enable-pcre2-32",
                          "--enable-pcre2grep-libz",
                          "--enable-pcre2grep-libbz2",
                          "--enable-jit"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system bin/"pcre2grep", "regular expression", prefix/"README"
  end
end
