class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.1.0/gcc-12.1.0.tar.xz"
  sha256 "62fd634889f31c02b64af2c468f064b47ad1ca78411c45abe6ac4b5f8dd19c7b"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_monterey: "e3e61b1ddba97ee4156243b6e4a75d2e7ab7772d7427f136d2db7f65e91c5429"
    sha256 arm64_big_sur:  "e6f7eaabc4d43eed86b0a0b737c2bf0e922a608686ddc1d033b872bba4f766f1"
    sha256 monterey:       "cea22bcae56ca4ab90f52d5cee01c68362a5a59cfe9e82e1e1003f5912346b72"
    sha256 big_sur:        "db306ab8ee3a4fab34538e632a83e8adc6e71cf714a6b5f047d4d20bed4b331b"
    sha256 catalina:       "ab2276b06f5740bdfc54f98a0469f94b9135456deaf785cf7318f622d35746e3"
    sha256 x86_64_linux:   "0a6b4a81b2d56f4b10e82735c29a20787f9d45d93d5425031ab4f089adab2008"
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
