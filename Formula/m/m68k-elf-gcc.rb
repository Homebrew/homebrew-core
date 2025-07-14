class M68kElfGcc < Formula
  desc "GNU compiler collection m68k-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "0cdf924191056c6e031693917100611ee49822804e0e79f8e0f50b4c56e269bc"
    sha256 arm64_sonoma:  "0d4302073e264000fb12a3d29ec231da28d65dbe66c3a8d36c9fb44e6b7aff09"
    sha256 arm64_ventura: "84d996e6f45cf1aafc3b0cbb4469f83dbfb30d56283223f9013469ce45d246ad"
    sha256 sonoma:        "fdb5f77a76a5906c161da0f582e25353f137d2b5499f8d8a4a0e69a469352218"
    sha256 ventura:       "ec5d0f17e32bba4373b493b15a6a85432d9fb3a8e8e8f747cdbd38543aad9805"
    sha256 arm64_linux:   "6fc90bc1eafa40db0a8093ee45df2833e1475c7ae60ac6e6288846d67a0bc459"
    sha256 x86_64_linux:  "4956d94e592faccc5b4008fda4ea7a1387cc8ca8c1d4255d6aeff582fbe6f9c0"
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "m68k-elf-binutils"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    target = "m68k-elf"
    mkdir "m68k-elf-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-headers",
                             "--with-as=#{Formula["m68k-elf-binutils"].bin}/m68k-elf-as",
                             "--with-ld=#{Formula["m68k-elf-binutils"].bin}/m68k-elf-ld",
                             "--enable-languages=c,c++,objc,lto",
                             "--enable-lto",
                             "--with-system-zlib",
                             "--with-zstd",
                             *std_configure_args
      system "make", "all-gcc"
      system "make", "install-gcc"
      system "make", "all-target-libgcc"
      system "make", "install-target-libgcc"

      # FSF-related man pages may conflict with native gcc
      rm_r(share/"man/man7")
    end
  end

  test do
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C
    system bin/"m68k-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-m68k",
                 shell_output("#{Formula["m68k-elf-binutils"].bin}/m68k-elf-objdump -a test-c.o")
  end
end
