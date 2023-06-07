class Figlet < Formula
  desc "Banner-like program prints strings as ASCII art"
  homepage "http://www.figlet.org/"
  url "http://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz"
  mirror "https://fossies.org/linux/misc/figlet-2.2.5.tar.gz"
  sha256 "bf88c40fd0f077dab2712f54f8d39ac952e4e9f2e1882f1195be9e5e4257417d"
  license "BSD-3-Clause"

  livecheck do
    url "http://ftp.figlet.org/pub/figlet/program/unix/"
    regex(/href=.*?figlet[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "0ebfa147cd1a513a86323167ab696a94b490dcd215d6685188bc376bf1313953"
    sha256 arm64_monterey: "87aa47afd19c8cd952a9a342a9afe32d0da2849ee1c1de2510949675a38327b8"
    sha256 arm64_big_sur:  "c11153896e225e3ce85db5dda5c85455422e542871c0495683aa49c8929cc6f8"
    sha256 ventura:        "3955d7572889134c95edc8ddf8bb2c01221e5c5ffed53b5410cf033a7d595795"
    sha256 monterey:       "d0e426869d73c174754374b2f91dad0b9464beae30f6d4dc73882777655c44cc"
    sha256 big_sur:        "c205792bc4f3305cc2fdccf672a9df7f2d415efc6c9b7ac2f00ccb44aa981cfc"
    sha256 catalina:       "b0ecddfbf1d1e1d45ff1d3cb1be1977fd80a7924c27a73d995435de9aff5ca66"
    sha256 mojave:         "906556c44706889c0170f4dfe7d7427f27122cee425042c3911f7266f9fc2e4c"
    sha256 high_sierra:    "3047847adef9cb5bd5588cf65f64bfcc0549ed44d4370a862071aba2f9d98ba6"
    sha256 sierra:         "c53966c742bf88b8481f6ed0bde1a951ea11185af2c631fb02b84fa7120f2e17"
    sha256 el_capitan:     "943067dae95de58518b20334aec401cf5fd24866ff77315c0d7bd8b5d4ab0011"
    sha256 x86_64_linux:   "94ef53c9339ca8a3da5a92168fde47b97bdb992c8dfe6b6603f79bbe07a8acff"
  end

  resource "contrib" do
    url "http://ftp.figlet.org/pub/figlet/fonts/contributed.tar.gz"
    mirror "https://www.minix3.org/distfiles-backup/figlet-fonts-20021023/contributed.tar.gz"
    mirror "https://downloads.sourceforge.net/project/fullauto/FIGlet%20Fonts/contributed.tar.gz"
    sha256 "2c569e052e638b28e4205023ae717f7b07e05695b728e4c80f4ce700354b18c8"
  end

  resource "intl" do
    url "http://ftp.figlet.org/pub/figlet/fonts/international.tar.gz"
    mirror "https://www.minix3.org/distfiles-backup/figlet-fonts-20021023/international.tar.gz"
    mirror "https://downloads.sourceforge.net/project/fullauto/FIGlet%20Fonts/international.tar.gz"
    sha256 "e6493f51c96f8671c29ab879a533c50b31ade681acfb59e50bae6b765e70c65a"
  end

  def install
    (pkgshare/"fonts").install resource("contrib"), resource("intl")

    chmod 0666, %w[Makefile showfigfonts]
    man6.mkpath
    bin.mkpath

    system "make", "prefix=#{prefix}",
                   "DEFAULTFONTDIR=#{pkgshare}/fonts",
                   "MANDIR=#{man}",
                   "install"
  end

  test do
    system "#{bin}/figlet", "-f", "larry3d", "hello, figlet"
  end
end
