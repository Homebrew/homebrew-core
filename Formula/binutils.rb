class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.35.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.35.tar.xz"
  sha256 "1b11659fb49e20e18db460d44485f09442c8c56d5df165de9461eb09c8302f85"
  license "GPL-2.0"

  bottle do
    sha256 "0493e76c9a163b6417716741bf01dc4e66f49c3e2a265a44042475aac43ab2c0" => :catalina
    sha256 "4a90201366ce8c935d9372d4b4f5438e6b3fdea3f738a3d6441ecf4946039601" => :mojave
    sha256 "b361b8cf1de6cabdb990cdd2d8b1fc7e1cf7ad9b8190d7f9feb11bf2579ecadb" => :high_sierra
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
                          "--enable-targets=all"
    system "make"
    system "make", "install"
    Dir["#{bin}/*"].each do |f|
      bin.install_symlink f => "g" + File.basename(f)
    end
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/strings #{bin}/strings")
  end
end
