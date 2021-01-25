class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-10.2.0/gcc-10.2.0.tar.xz"
  sha256 "b8dd4368bb9c7f0b98188317ee0254dd8cc99d1e3a18d0ff146c855fe16c1d8c"
  license "GPL-2.0"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "774bb133598e76c19daa758e533132d632e6b541a4f6c348bc1428b573bb5c58" => :big_sur
    sha256 "8e258af70b398807c115631de8a1dc8c6ebdb3be870fe26410c14e91a7659a58" => :catalina
    sha256 "4c14d4308435c164f92de628f8e1b97a63692fb0b3ff083c083a64fed1c72870" => :mojave
    sha256 "c8d9a65d529d5c9219b451dfd724c7df0275df5f9c6138eb3db173b783c07372" => :high_sierra
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"

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
                             "--enable-languages=c,c++",
                             "SED=/usr/bin/sed"
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
