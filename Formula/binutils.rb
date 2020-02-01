class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.xz"
  sha256 "f00b0e8803dc9bab1e2165bd568528135be734df3fabf8d0161828cd56028952"

  bottle do
    sha256 "c9043b4615a1462646f0af1296fdc4ec70fc654fb7daff77f9c4e73373d1b312" => :catalina
    sha256 "c97046dc6f519c176addcd4ed37afddc0553e7eebf8b30fbd5a5b64487b9cdc4" => :mojave
    sha256 "021367441684b194be93d5be015930e1507a6a2d7c7201d3815740a052f0b87a" => :high_sierra
  end

  keg_only :provided_by_macos,
           "because Apple provides the same tools and binutils is poorly supported on macOS"

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
