class M68kElfGcc < Formula
  desc "GNU compiler collection m68k-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "5dee058453b8d2a9054914b5709c45897af9765926b775c1a5f0349df04d74a7"
    sha256 arm64_sequoia: "c0c93d2de9246e10fd4205b012252dc4dda07232aabfd0c4e83b234531ffc987"
    sha256 arm64_sonoma:  "dcdf47c0973a9a57707d99a4b73bb75855233577d857deaba969597d821d286d"
    sha256 sonoma:        "e428b26feaf88e81b32f5333a721d9c81c9818ec8b35c5ff954217835e6e6b81"
    sha256 arm64_linux:   "79fd3246d37dac25bf0d3549b4d1024c82b054597f6062e3ad7cceab0c83372b"
    sha256 x86_64_linux:  "2664d84359ca4f0303dd6deeeb48957461c70201dd0d7f39f44a8d056d136bb6"
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "m68k-elf-binutils"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
