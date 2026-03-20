class ArmNoneEabiGcc < Formula
  desc "GNU compiler collection for arm-none-eabi"
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
    sha256 arm64_tahoe:   "4e862be029fd2e27e1d2614a54581846fdf3cf1f55e4d3e75eb1d097ffaafc39"
    sha256 arm64_sequoia: "8b0034c3bc3e3ec1d1e7b3d4da1fc9208f9ddcaf182bf95a85dc921ad394b2ab"
    sha256 arm64_sonoma:  "7586b52ffdc271857080b690184c269975c0d885c8688653c01c063e321fa02d"
    sha256 sonoma:        "4a64941cdc4bc7110a72969d07e89e17944392073a1dce1a90ab31fe052303ad"
    sha256 arm64_linux:   "a52b2e1db4a395276e704677d2dd7f164ab9fd277ad2353b8f117d45ca917a6e"
    sha256 x86_64_linux:  "ef7aec12914835857f8ade168373e744061017468638dab8275ab7a28a3764b8"
  end

  depends_on "arm-none-eabi-binutils"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
                             "--enable-multilib",
                             "--with-multilib-list=aprofile,rmprofile",
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
    system bin/"arm-none-eabi-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-littlearm",
                 shell_output("#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-objdump -a test-c.o")
  end
end
