class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.1.tar.xz"
  sha256 "3ced91db9bf01182b7e420eab68039f2083aed0a214c0424e257eae3ddee8607"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    sha256 "939b10a1c2ffd8c0404827adcb53d8581e3187b418a3f460c7b8ca80083c0265" => :big_sur
    sha256 "f5b1ef7f5209ccceee53625f240fe85ffa42661d6d7a1058d879d544c3d2076b" => :catalina
    sha256 "12d25883cb8fd258343baba320ad465da3ce929c988b9950545e8b4d1a403a7d" => :mojave
    sha256 "56e4eba418acac34302d7b46bc04dbf3c64ddffa2a2830cd5f6ad12911e33294" => :high_sierra
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides the same tools"

  uses_from_macos "zlib"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-deterministic-archives",
                          "--prefix=#{prefix}",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--disable-werror",
                          "--enable-interwork",
                          "--enable-multilib",
                          "--enable-64-bit-bfd",
                          "--enable-gold",
                          "--enable-plugins",
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold"
    on_macos do
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    end

    on_linux do
      # Reduce the size of the bottle.
      system "strip", *Dir[bin/"*", lib/"*.a"]
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
