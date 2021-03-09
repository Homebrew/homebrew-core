class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.36.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.36.1.tar.xz"
  sha256 "e81d9edf373f193af428a0f256674aea62a9d74dfe93f65192d4eae030b0f3b0"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.0-or-later", "LGPL-3.0-only"]

  bottle do
    sha256 arm64_big_sur: "f0c23d8672a107f94bb46eec9cae654b1a9abf663e6d25ec82467f0dfa45dff1"
    sha256 big_sur:       "993ab1e0149a47224c4e7063be178ff5d551b2ea6d2a79805f03ca40cd5f1279"
    sha256 catalina:      "d3112607a4820d58df8d1fc0fd3ac998ba9ba8563245e72c9e197c50b333748c"
    sha256 mojave:        "06de25d200fd389ee4157a278abe261e20c18f8f6ad28d9519a4a4001b5b027e"
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
