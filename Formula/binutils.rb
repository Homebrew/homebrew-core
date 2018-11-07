class Binutils < Formula
  desc "FSF/GNU ld, ar, readelf, etc. for native development"
  homepage "https://www.gnu.org/software/binutils/binutils.html"
  url "https://ftp.gnu.org/gnu/binutils/binutils-2.31.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/binutils/binutils-2.31.1.tar.gz"
  sha256 "e88f8d36bd0a75d3765a4ad088d819e35f8d7ac6288049780e2fefcad18dde88"
  revision 2

  bottle do
    sha256 "b4ed7c31d6738e2f084e801cb747f98cb63a4857ab5044c757ae361e3a68d32b" => :mojave
    sha256 "35253f02238a83fcfc243a79b1fb445d6bec93b2a602789e063896d03f0012f5" => :high_sierra
    sha256 "3fa0ed58f41b068c5c6e81e2ae99879f0f36f9588814f52be8806e09a3b7bca5" => :sierra
  end

  keg_only :provided_by_macos,
           "because Apple provides the same tools and binutils is poorly supported on macOS"

  # Adds support for macOS 10.14's new load commands.
  # Will be in the next release.
  # https://github.com/Homebrew/homebrew-core/issues/32516
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/91dc37fa4609cf1d040b5ede9f2eb971f3730597/binutils/add_mach_o_command.patch"
    sha256 "abb053663a56c5caef35685ee60badf57e321b18f308e7cbd11626b48c876e8c"
  end

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
