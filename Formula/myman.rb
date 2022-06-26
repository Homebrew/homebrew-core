class Myman < Formula
  desc "Text-mode videogame inspired by Namco's Pac-Man"
  homepage "https://myman.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/myman/myman-cvs/myman-cvs-2009-10-30/myman-wip-2009-10-30.tar.gz"
  sha256 "bf69607eabe4c373862c81bf56756f2a96eecb8eaa8c911bb2abda78b40c6d73"
  head ":pserver:anonymous:@myman.cvs.sourceforge.net:/cvsroot/myman", using: :cvs

  bottle do
    rebuild 2
    sha256 arm64_monterey: "7572bde41926ba4a33b300b0e43b890648fb8d19e47e4a50b43608e99c9b8e9a"
    sha256 arm64_big_sur:  "a38be300e040956aa8f9d997a715c91152868d5aeaadc6406330729523036828"
    sha256 monterey:       "0b4412e46e30f8970f331f4948e3210b956abceceebbb0b480ace2af2fa3973a"
    sha256 big_sur:        "651100d0ad19af5ef07a55c1bd0d728211d8810e9da024d9344f3ed5c024e46b"
    sha256 catalina:       "90c5dee20ff2517495521e588b09678789462a8a63dc6a600da13a76cb5e86b0"
    sha256 mojave:         "1ff1470d676dabb177f06c2683b67da5e70e39bbab28f7457762d4adda5cffb0"
    sha256 high_sierra:    "b5f0af51ce1098ea35e48bc50f4097cbb9e647989decd6d7791476b062ef7582"
    sha256 sierra:         "376c71ad2f5abcc0233b3873d70cc963e54ac0ca00a552eceb025ac09b931ff6"
    sha256 el_capitan:     "d3b66de7eae03edecb2573524d94239bd013ffd57eeb1980411da12f6d2b2b98"
    sha256 yosemite:       "b318e0b227a3ad281afe95edc5a0cc7ab0b1d5e46b1699e6221eb201de869b48"
    sha256 x86_64_linux:   "28f96eb2fba35b8c50f166eecd9b48dc8336229e97425f290209d15e9526eeeb"
  end

  depends_on "groff" => :build

  uses_from_macos "ncurses"

  on_macos do
    depends_on "coreutils" => :build
    depends_on "gnu-sed" => :build
  end

  on_linux do
    depends_on "util-linux" => :build # for `col`
  end

  def install
    if OS.mac?
      ENV["RMDIR"] = "grmdir"
      ENV["SED"] = "gsed"
      ENV["INSTALL"] = "ginstall"
    end
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"myman", "-k"
  end
end
