class M68kElfGcc < Formula
  desc "GNU compiler collection m68k-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "c59ec5184608bc182b9bdb8bd644a08f50d827c348da0db94fb66e3a05241b42"
    sha256 arm64_sequoia: "a52e3a7eb57158c469bd304b8e9dfcec9b01105edcc8b38d86c61d073348c75a"
    sha256 arm64_sonoma:  "d654cf1135a3d8c95ab1b77d6159f91533c03feab8941182543249fabc270c93"
    sha256 arm64_ventura: "e16c7e5208a4e217cd848e4220808a3bcd18cabc513e91dc87aed4c68dea272a"
    sha256 sonoma:        "2cdfa869a7c4d710caa396db568b081ba0ff350b6217878363dff10da6a14d18"
    sha256 ventura:       "4566ed2a81bc500effc80d862cc415648fb01d2c351ad80edc007e661d73dc79"
    sha256 arm64_linux:   "f3b22e0ba0dd247728835751fbdab62205d850fbd9e7d45b4bd2a3183d3e5493"
    sha256 x86_64_linux:  "1744482a14970aabb590409b71ddc51dac2b12e5bbb0737f505350a19946663f"
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
