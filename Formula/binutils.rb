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
    sha256 "6ea1be54245d0b0566c10bae2f8b52820fd80d832cd47d7414b82681157c1612" => :big_sur
    sha256 "911103dd301bcd70ae64882fb6c726b7ef11fb1fec21b99a2471d7071240750d" => :arm64_big_sur
    sha256 "6f00f0f0fdd76662b39e851d694c7b269bb7a4931154c4b637b744525ba3fffc" => :catalina
    sha256 "b0a8a94f858655bea9b4af4adc278fb96d3778fe6aadbb48429158a479821c3d" => :mojave
    sha256 "e5eb466f9073bbcbd906edf23c04ea94942a9faefe8deba595cf95831150dbd8" => :x86_64_linux
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
