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
    rebuild 1
    sha256 arm64_sonoma:   "46d9091ec4a27e85fbce47c58793407ab4f143012ac9f4f17191ef902eef2941"
    sha256 arm64_ventura:  "7e09ea2ed7802bd7f3de38171804237b118513514a39418b75b361cf4335502d"
    sha256 arm64_monterey: "2ce4b4c16a32fac69c6284cdd3d7abd60438ca4c625c6c8aab9d3764790927cf"
    sha256 sonoma:         "402647439ebd5043aa51e8e9dcb9b370928830a55ed2c27ec5a0070ec06ed40d"
    sha256 ventura:        "67fda5c96700afa1ab461ff243f264ed9b967d32d1d42a438ee0ce07c249632c"
    sha256 monterey:       "e572a71afe82a76ef68975aada02dafd0560f3949b8259d4be31648fe9a25e7f"
    sha256 x86_64_linux:   "f559f76321f645d0679b74d21053b8cbab1dc7f1d00052c5b4bfb0aa4cc1b259"
  end

  depends_on "arm-none-eabi-binutils"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    target = "arm-none-eabi"
    mkdir "arm-none-eabi-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-headers",
                             "--with-as=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-as",
                             "--with-ld=#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-ld",
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
