class M68kElfGcc < Formula
  desc "GNU compiler collection m68k-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  sha256 "50efb4d94c3397aff3b0d61a5abd748b4dd31d9d3f2ab7be05b171d36a510f79"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "e78de1e22ba43aa3ae17849ad87f4aff4c76c3e8571c57afefb91396c8618efa"
    sha256 arm64_sequoia: "e0aaa0cc53f84217a6767131f837df0ceeec4e6dda595e879190ab0b34a3e307"
    sha256 arm64_sonoma:  "179476e0b55958e681c46681de9e821a261d33499249931fb4d20860b00a61e8"
    sha256 sonoma:        "f3393d3df791ecdbb4d36be1ce9e67556e4ea286ee2a63cde67e482791e81585"
    sha256 arm64_linux:   "c2aa704629559c1abfb2f6da5c85fb2f56902b4cfb8baba5e023215964baff7b"
    sha256 x86_64_linux:  "a13487b413e283dc245e5e3cb88c787d7b2cb128053764b7dde321a1ab73833f"
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "m68k-elf-binutils"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
