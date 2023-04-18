class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "8a5a2ca3d7e53db7899cf03e878f17413c7604e87c8fc80d639e04e79c19aa36"
    sha256 arm64_monterey: "f5d9fd202404e69e3d69f59e4258896fa0b8e27f8f9cc6873b66c769ebfadaae"
    sha256 arm64_big_sur:  "49c73ae5b7fd21768d3467465c2e0a7da1be3f414757a9a72fc6c582f91537ba"
    sha256 ventura:        "09121e3fb58af2f29a841faa421b3865ec36848942b598ee83051f511e9cafb0"
    sha256 monterey:       "28bd30c6e0beecd74e080bac0676916933479154e6e067409d1a45558a5e7cab"
    sha256 big_sur:        "651f6c7cf15bd9e4751e4295b03fb2b3be7956a61593696c150bab57c8fdd64b"
    sha256 catalina:       "89c4fde526913e9aa04fffa842f4a1e1f7a95b05a7dcc5427e44aa466cc6c4ac"
    sha256 x86_64_linux:   "2c9a3e4a9165547f2364e15f5c642a99689c755139a8b93bdbe15344957320a1"
  end

  depends_on "aarch64-elf-binutils"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"

  def install
    target = "aarch64-elf"
    mkdir "aarch64-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-as",
                             "--with-ld=#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-ld",
                             "--enable-languages=c,c++"
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      (share/"man/man7").rmtree
    end
  end

  test do
    (testpath/"test-c.c").write <<~EOS
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    EOS
    system "#{bin}/aarch64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-objdump -a test-c.o")
  end
end
