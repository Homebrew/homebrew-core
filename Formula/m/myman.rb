class Myman < Formula
  desc "Text-mode videogame inspired by Namco's Pac-Man"
  homepage "https://myman.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/myman/myman-cvs/myman-cvs-2009-10-30/myman-wip-2009-10-30.tar.gz"
  sha256 "bf69607eabe4c373862c81bf56756f2a96eecb8eaa8c911bb2abda78b40c6d73"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:    "ad0b203a8eb32295e620487891e41c177d0b4fb923060421f7b12dfab97b5c03"
    sha256 arm64_sequoia:  "0dc21521eed45cafe254d4827b33de42b08fd4be2eeae5dc0bfe88f6fe6dbf6f"
    sha256 arm64_sonoma:   "501fa86739940d84b19c81b0f93a3ddd81031f052760c8409bdfa3f61a86a406"
    sha256 arm64_ventura:  "4a37b7df0fde91a64eeec5ae4032d2c460b6524310c51819624c16c8904e7020"
    sha256 arm64_monterey: "7572bde41926ba4a33b300b0e43b890648fb8d19e47e4a50b43608e99c9b8e9a"
    sha256 arm64_big_sur:  "a38be300e040956aa8f9d997a715c91152868d5aeaadc6406330729523036828"
    sha256 sonoma:         "90c2e1f670e45f8df399395348af8d3c4112ce2bf4e556ef7442f685d27b5890"
    sha256 ventura:        "ddbf3e40844f79bb2c6401a01db921f954980a7784f23838d3876447eb66c0ff"
    sha256 monterey:       "0b4412e46e30f8970f331f4948e3210b956abceceebbb0b480ace2af2fa3973a"
    sha256 big_sur:        "651100d0ad19af5ef07a55c1bd0d728211d8810e9da024d9344f3ed5c024e46b"
    sha256 catalina:       "90c5dee20ff2517495521e588b09678789462a8a63dc6a600da13a76cb5e86b0"
    sha256 arm64_linux:    "f33b146715c2765ab0994572a9692ee5cd84cf216926262810483f688ff8ce81"
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
