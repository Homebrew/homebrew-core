class Myman < Formula
  desc "Text-mode videogame inspired by Namco's Pac-Man"
  homepage "https://myman.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/myman/myman-cvs/myman-cvs-2009-10-30/myman-wip-2009-10-30.tar.gz"
  sha256 "bf69607eabe4c373862c81bf56756f2a96eecb8eaa8c911bb2abda78b40c6d73"
  head ":pserver:anonymous:@myman.cvs.sourceforge.net:/cvsroot/myman", :using => :cvs

  bottle do
    rebuild 2
    sha256 "90c5dee20ff2517495521e588b09678789462a8a63dc6a600da13a76cb5e86b0" => :catalina
    sha256 "1ff1470d676dabb177f06c2683b67da5e70e39bbab28f7457762d4adda5cffb0" => :mojave
    sha256 "b5f0af51ce1098ea35e48bc50f4097cbb9e647989decd6d7791476b062ef7582" => :high_sierra
    sha256 "376c71ad2f5abcc0233b3873d70cc963e54ac0ca00a552eceb025ac09b931ff6" => :sierra
    sha256 "d3b66de7eae03edecb2573524d94239bd013ffd57eeb1980411da12f6d2b2b98" => :el_capitan
    sha256 "b318e0b227a3ad281afe95edc5a0cc7ab0b1d5e46b1699e6221eb201de869b48" => :yosemite
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
