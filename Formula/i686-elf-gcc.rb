class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-11.1.0/gcc-11.1.0.tar.xz"
  sha256 "4c4a6fb8a8396059241c2e674b85b351c26a5d678274007f076957afa1cc9ddf"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  bottle do
    rebuild 1
    sha256 arm64_big_sur: "06ffaa046cdc144d56fec59df4c77790fe3dde2cba2e3a11a30c3cf01ee8ce0f"
    sha256 big_sur:       "714c96b4c9174aaf2945be91156cc273da8f53628b213f51abb905df4a2a077c"
    sha256 catalina:      "c0305f2b0b27c90931be17c7979c2d7f9dcac05c48781dcf2184014dac17537a"
    sha256 mojave:        "274ac95b8ddc3b560aedb197ffa54ac51020a09fd7814d31d5273fe68ec15a82"
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
    mkdir "i686-elf-gcc-build" do
      system "../configure", "--target=i686-elf",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/i686-elf-gcc",
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
