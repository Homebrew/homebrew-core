class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.1.0/gcc-13.1.0.tar.xz"
  sha256 "61d684f0aa5e76ac6585ad8898a2427aade8979ed5e7f85492286c4dfc13ee86"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "ad3c875bea1f7cbc40b7774a3d93a7c00c81cbad5fa480d589e634f14c795c8c"
    sha256 arm64_monterey: "f13ee9cbde2459869640a33ab7b63f35556fb4debdc9b80ae6609a9d69b5483e"
    sha256 arm64_big_sur:  "c3cf7306a688ce198eb77010f037c5f41f0f54122273556ef91e3143fa6db4d0"
    sha256 ventura:        "214edfc4918da716282d650ca5a3dfbd19cc202d727852e3ecf9d28a1c8cd362"
    sha256 monterey:       "047730755fc4980766e83b50f89ab10879d318a831dac18bbd6a3e649e392421"
    sha256 big_sur:        "2680038ad36aa28cb6e6136bf737076726a71ccaac2bc69d99680c4c8bbd8b02"
    sha256 x86_64_linux:   "f734e296fc9c68be83c662c9dc242eafcd6a1d35a9ad66d4c938cb03b201071d"
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
