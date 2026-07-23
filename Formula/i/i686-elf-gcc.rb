class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  sha256 "50efb4d94c3397aff3b0d61a5abd748b4dd31d9d3f2ab7be05b171d36a510f79"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "090b7a85c9fbb04e0662104d223e47bb97c4e33b3c3d1da535b15dd5d4aa27a1"
    sha256 arm64_sequoia: "2a63d7663061fc9232c11a88aa7e0c0d797dad7ef77f298f5196aee83505ade7"
    sha256 arm64_sonoma:  "15caf35e87a4e5ca9f9825d53c6ee8275de2d17df37fe839a8e2593cea2cdd40"
    sha256 sonoma:        "b81d61dae7d9a10eea7cf06cb81d881b2fc985251fc8ab49373d371da04c8f9b"
    sha256 arm64_linux:   "6e0196289c2e49595b737126b9e59b0457634a25703a763a07920ed5c938f363"
    sha256 x86_64_linux:  "5c0cbb48862b37c1e50479abaf6f39c3000fb21e92f12c73ef8396aad27b6c3e"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "i686-elf"
    mkdir "i686-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-isl",
                             "--without-headers",
                             "--with-as=#{Formula["i686-elf-binutils"].bin}/i686-elf-as",
                             "--with-ld=#{Formula["i686-elf-binutils"].bin}/i686-elf-ld",
                             "--with-system-zlib",
                             "--enable-languages=c,c++"
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

    system bin/"i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
    assert_match "file format elf32-i386", output
  end
end
