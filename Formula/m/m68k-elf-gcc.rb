class M68kElfGcc < Formula
  desc "GNU compiler collection m68k-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "38e9fd3f2a4e362414107ed623644faa9978652e7c35fca9835ed0e26ecaaae4"
    sha256 arm64_sonoma:  "52914f0b6bbfb12b267492017eb5bcf9267cfb91fe8154ee225d16fbcf58b6ae"
    sha256 arm64_ventura: "5650b3c62fbb098712a8a2615346b5ed924e24b651cc178fec307184cc32db14"
    sha256 sonoma:        "79c3926b40815efe59470e1571bcbc5b474991cf9f37261e1ff92254c950dcd5"
    sha256 ventura:       "6b8e8dc98de69e7c15500ebad0e00af992a206246f7d7f1ea45ebe68d3021b1c"
    sha256 x86_64_linux:  "aacfe3fc4c1bf0ffe6d71ed638677b27ba7a34986e54e60b00fe63c5e6c3dd7b"
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
