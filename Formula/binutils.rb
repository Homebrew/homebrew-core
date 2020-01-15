class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.33.1.tar.gz"
  sha256 "98aba5f673280451a09df3a8d8eddb3aa0c505ac183f1e2f9d00c67aa04c6f7d"

  bottle do
    sha256 "c9043b4615a1462646f0af1296fdc4ec70fc654fb7daff77f9c4e73373d1b312" => :catalina
    sha256 "c97046dc6f519c176addcd4ed37afddc0553e7eebf8b30fbd5a5b64487b9cdc4" => :mojave
    sha256 "021367441684b194be93d5be015930e1507a6a2d7c7201d3815740a052f0b87a" => :high_sierra
  end

  uses_from_macos "zlib"

  keg_only :provided_by_macos,
           "because Apple provides the same tools and binutils is poorly supported on macOS"

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
