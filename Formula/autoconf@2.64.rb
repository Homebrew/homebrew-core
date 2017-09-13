class AutoconfAT264 < Formula
  desc "Automatic configure script builder"
  homepage "https://www.gnu.org/software/autoconf/"
  url "https://ftp.gnu.org/gnu/autoconf/autoconf-2.64.tar.gz"
  mirror "https://ftpmirror.gnu.org/autoconf/autoconf-2.64.tar.gz"
  sha256 "a84471733f86ac2c1240a6d28b705b05a6b79c3cca8835c3712efbdf813c5eb6"

  bottle do
    sha256 "f3e6ec0d2d643337f1a5198263a55ec9b70d6638171368b434499be72dcdc2f4" => :sierra
    sha256 "86e61ce217daaab94993d3be3b479a1622e8afe534f36e6389a02393b73d9420" => :el_capitan
    sha256 "05fff25a6e191c780080c0d5cd6596a929a20deb823e26ebd61bdd0d55dd30ba" => :yosemite
  end

  def install
    system "./configure", "--program-suffix=264",
                          "--prefix=#{prefix}",
                          "--with-lispdir=#{elisp}",
                          "--infodir=#{pkgshare}/info",
                          "--datadir=#{pkgshare}"
    system "make", "install"
  end

  test do
    cp pkgshare/"autoconf/autotest/autotest.m4", "autotest.m4"
    system bin/"autoconf264", "autotest.m4"
  end
end
