class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  depends_on "aarch64-elf-binutils"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"

  # Remove when upstream has Apple Silicon support
  if Hardware::CPU.arm?
    patch do
      # patch from gcc-11.1.0-arm branch
      url "https://github.com/fxcoudert/gcc/commit/eea3046c5fa62d4dee47e074c7a758570d9da61c.patch?full_index=1"
      sha256 "b55ca05a0ed32f69f63bbe708568df5ad62d938da0e34b515d601bb966d32d40"
    end
  end

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
