class ArmNoneEabiGcc < Formula
  desc "GNU compiler collection for arm-none-eabi"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia:  "7e99a55c38570d03ab85afd156bad3a40153405d8e8427ab4e75e8291a472acb"
    sha256 arm64_sonoma:   "110e080cf05531cf7d97c9efc1c39b23b2bd2bec38cf536814d94ea6b0103c27"
    sha256 arm64_ventura:  "7eb18a5b0768335ec37cd994e073e7c7bd8b3e32437c6c8fa8966f4014eecc42"
    sha256 arm64_monterey: "7feb6f35385f0c35b2b74ef2b735ba1040e4fbf82a3386ffa6e97a92a07cc755"
    sha256 sonoma:         "7ff497dd7128127e645c9994e914a4fd72feefa12a1010e6f99abaa758467c47"
    sha256 ventura:        "7e3aa22bd54f564cd5c51a381b3822ceb6b0b3d19a04eceb2040691a26ab581e"
    sha256 monterey:       "1d4d2b9c82111c5e906ae204ec2905a6e9ca2d06e5a0487e62451b9b65e10676"
    sha256 x86_64_linux:   "b5bb4cee7a5e1d1a6eb896b40854911a4616e98a0b66b6a8590a9b481a8b308e"
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
      rm_r(share/"man/man7")
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
    system bin/"arm-none-eabi-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-littlearm",
                 shell_output("#{Formula["arm-none-eabi-binutils"].bin}/arm-none-eabi-objdump -a test-c.o")
  end
end
