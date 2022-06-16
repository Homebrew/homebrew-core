class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.38.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.38.tar.xz"
  sha256 "e316477a914f567eccc34d5d29785b8b0f5a10208d36bbacedcc39048ecfe024"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256                               arm64_monterey: "688777b47a3ccd4bf77ba9fa46c0ed66dd0c8a662dbd9c0021e574df5c87a783"
    sha256                               arm64_big_sur:  "794eab8c0705e58f4578480ac49225a96bdb8d25ae9642a9e9161730f354e83a"
    sha256                               monterey:       "6e8ef1eab4c0ca426453a36584a6791fe16619a3641646feb1932423c5e0e27d"
    sha256                               big_sur:        "0bdf6d0186c29f175d4493118a4086f0c24056088359fe0c333123e1b9e03759"
    sha256                               catalina:       "f32ac82487eff8fb84bd6d6780213f9c152dc2403e67d6adda50f9c91d5a889e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c260a27d2cec70f223f75b8f56e158db62c2f5bc9f25f39d7332a02c2ff03ac"
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
                          "--enable-targets=all",
                          "--with-system-zlib",
                          "--disable-nls"
    system "make"
    system "make", "install"
    bin.install_symlink "ld.gold" => "gold"
    if OS.mac?
      Dir["#{bin}/*"].each do |f|
        bin.install_symlink f => "g" + File.basename(f)
      end
    else
      # Reduce the size of the bottle.
      system "strip", *Dir[bin/"*", lib/"*.a"]
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
