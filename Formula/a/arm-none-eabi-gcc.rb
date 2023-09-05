class ArmNoneEabiGcc < Formula
  desc "GNU compiler collection for arm-none-eabi"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "4f2f39fafa158e109e7ead969e9fab8d1ea14e4dcf9e78fe2e0f959195c6d906"
    sha256 arm64_monterey: "9eaf4e0fa6ba13e7d7f355c7fef36b264c869194dde1be79a824c509c18489f3"
    sha256 arm64_big_sur:  "9c7d8c3936e3ab6151fc0e5ccf2cf9ab740bb8c09e74c1d51deffc1e40966201"
    sha256 ventura:        "605716f2172a781934637d78a772fa6b245f786d60d5fcecd8f7b1f9e8d54f36"
    sha256 monterey:       "86438c6a8f263a5b0942bab2f7eb9b3259f70e3bea77bd5b7f9c1ea4accd1322"
    sha256 big_sur:        "a156db223f16707396358727e4c178d427496e8174d7f133b51f5efa1643504d"
    sha256 x86_64_linux:   "e8ae63c45c6b9fc368896e5fe83879d3e7f4682400dcb6cefea33fa684f441f3"
  end

  depends_on "arm-none-eabi-binutils"
  depends_on "gmp"
  depends_on "libmpc"
  depends_on "mpfr"

  def install
    target = "arm-none-eabi"
    mkdir "arm-none-eabi-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-as",
                             "--with-ld=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-ld",
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
    system "#{bin}/arm-none-eabi-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-littlearm",
                 shell_output("#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-objdump -a test-c.o")
  end
end
