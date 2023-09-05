class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "52fbab7e246024b0ab64be29079ab0d9acc2293963a9d8cb236260afc4df9179"
    sha256 arm64_monterey: "1edf222b87033c0ba5e5e5eb6a37a4a02cfdd2eaebb16fd59d530672d9743b8f"
    sha256 arm64_big_sur:  "335fd71e860fbed870ada71c893e520901530ba04743de7d57fe321c901efd27"
    sha256 ventura:        "3f0f2a063e451533e86db1ffcebf5cbee33348e684ed4ca03c2f6154377496ed"
    sha256 monterey:       "b9c9ec0616f365523345ec8317f2a53f2a0de2069f83082d96e0bfe801adcca4"
    sha256 big_sur:        "60f1e4b14e7b7c5e85f6fe0aa7cb9e63ad102993f6e9b3f75eaf4018067058ea"
    sha256 x86_64_linux:   "92db41fba79e8f057480e9223ff53cea160a6d0256d96752d5ff3a8fa2e42a58"
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
