class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "dc1192f46f2f58ad2d4d72e774114a707ff15e0bbac8f02f6868fa5b0f58387e"
    sha256 arm64_sequoia: "336cc59b76765bf151e7559e9cd1d470af2ab4bef9d24270cb656867becde841"
    sha256 arm64_sonoma:  "7f9ad28884f1c2f7b9c0b53ad1e59018fa2728f5214f964018dcc76b3e513aba"
    sha256 sonoma:        "abbfb1ae2d570c345fc35aa00e30ae1f63e0f55e04e1e4beb1216d8536499c60"
    sha256 arm64_linux:   "75c212bc07d5432ac8d8d0cba1159946e5be4a4272e8c34a0693d2052ac1c11c"
    sha256 x86_64_linux:  "40dc3970e637b82e36c47783c9956ca24d3ccd15e69ce077867bd84ca0c488fa"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
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
                             "--with-system-zlib",
                             "--enable-languages=c,c++"
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

    system bin/"i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
    assert_match "file format elf32-i386", output
  end
end
