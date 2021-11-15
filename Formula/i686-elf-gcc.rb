class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz"
  sha256 "d08edc536b54c372a1010ff6619dd274c0f1603aa49212ba20f7aa2cda36fa8b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_monterey: "8ae4f914695514bd00df96e82b12dfa1fe8b20576c0b028fc4e4e3326ecdc921"
    sha256 arm64_big_sur:  "03ea1c0b8db4064c4acd673fb1138d410699bd37c74db3e255479f93fe0f991b"
    sha256 monterey:       "c7d063f66f7179bd6f54ec8b6c2ee62954f128a73fc9674c3338868e37790bb3"
    sha256 big_sur:        "cbf70ba4c4dcd222b84b9bde4e3f69a8c621959e20facaa8677ebd0b0f14d4da"
    sha256 catalina:       "7aec8ee5b87f0a56236b59c4e796ec8eb5e991b3d2163a745bc9dbc12068592d"
    sha256 mojave:         "b0f9c1aafd4ecaace843bb77ec4062a7dc0f3b61f40506c762ad79d586811a51"
    sha256 x86_64_linux:   "33a850dd3e3c9b93c2899ff81ddd4199a942ac763691e829733ec87aa5eea732"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
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
    target = "i686-elf"
    mkdir "i686-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["i686-elf-binutils"].bin}/i686-elf-as",
                             "--with-ld=#{Formula["i686-elf-binutils"].bin}/i686-elf-ld",
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
    system "#{bin}/i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-i386",
      shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
  end
end
