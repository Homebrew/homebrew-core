class Myman < Formula
  desc "Text-mode videogame inspired by Namco's Pac-Man"
  homepage "https://myman.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/myman/myman-cvs/myman-cvs-2009-10-30/myman-wip-2009-10-30.tar.gz"
  sha256 "bf69607eabe4c373862c81bf56756f2a96eecb8eaa8c911bb2abda78b40c6d73"
  head ":pserver:anonymous:@myman.cvs.sourceforge.net:/cvsroot/myman", :using => :cvs

  bottle do
    sha256 "0d4f0baea895f5c18f0719ddefe41c7a91a475e4f58dccaaf001c7efebe6d0ea" => :sierra
    sha256 "afa7eac94ad1954334d4e2574b40b763bbbb354572005552f3482f4c6eab27f2" => :el_capitan
    sha256 "9b14137f2ae42a2e13bd1066d43467f0e7a647df225b2d013c64fdb8cead3ac3" => :yosemite
  end

  depends_on "coreutils" => :build
  depends_on "gnu-sed" => :build
  depends_on "groff" => :build

  def install
    ENV["RMDIR"] = "grmdir"
    ENV["SED"] = "gsed"
    ENV["INSTALL"] = "ginstall"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/myman", "-k"
  end
end
