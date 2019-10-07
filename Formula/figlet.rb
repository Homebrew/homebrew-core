class Figlet < Formula
  desc "Banner-like program prints strings as ASCII art"
  homepage "http://www.figlet.org/"
  url "http://ftp.figlet.org/pub/figlet/program/unix/figlet-2.2.5.tar.gz"
  mirror "https://fossies.org/linux/misc/figlet-2.2.5.tar.gz"
  sha256 "bf88c40fd0f077dab2712f54f8d39ac952e4e9f2e1882f1195be9e5e4257417d"

  bottle do
    sha256 "b0ecddfbf1d1e1d45ff1d3cb1be1977fd80a7924c27a73d995435de9aff5ca66" => :catalina
    sha256 "906556c44706889c0170f4dfe7d7427f27122cee425042c3911f7266f9fc2e4c" => :mojave
    sha256 "3047847adef9cb5bd5588cf65f64bfcc0549ed44d4370a862071aba2f9d98ba6" => :high_sierra
    sha256 "c53966c742bf88b8481f6ed0bde1a951ea11185af2c631fb02b84fa7120f2e17" => :sierra
    sha256 "943067dae95de58518b20334aec401cf5fd24866ff77315c0d7bd8b5d4ab0011" => :el_capitan
    sha256 "0a1b051fb0143dbfca1da36c83eca8580c215ff155e0dc755a924ce1f53a4b46" => :yosemite
    sha256 "3d33cf3ee819346dc431c37f07e2051c9f92d222cb35d330a41ca88bd5153e2d" => :mavericks
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
