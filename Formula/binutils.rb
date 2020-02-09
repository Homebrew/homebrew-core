class Binutils < Formula
  desc "GNU binary tools for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.34.tar.xz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.34.tar.xz"
  sha256 "f00b0e8803dc9bab1e2165bd568528135be734df3fabf8d0161828cd56028952"

  bottle do
    sha256 "1e21593a927df65e405f9d3bdc8f86fe83b1236c5c945641a2de775c99327953" => :catalina
    sha256 "142e380448ac77bc0f7974ff9b9ddae6a90c4ef5f182cac0c2b029baa8460173" => :mojave
    sha256 "87bda0c909a5bd2043d35b073f2268cac7aed074a89d903973e4909d68dfdf46" => :high_sierra
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
