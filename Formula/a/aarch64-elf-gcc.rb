class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-13.2.0/gcc-13.2.0.tar.xz"
  sha256 "e275e76442a6067341a27f04c5c6b83d8613144004c0413528863dc6b5c743da"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }
  revision 1

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "f13a2ab5a45bd03b1d9a664ffb0524d4a504f09020cbfaed74cbd8551f37457c"
    sha256 arm64_ventura:  "1edb3ad6987f0021ca659bb223a473504e6783b586898660de4098db2a933716"
    sha256 arm64_monterey: "bcd7f75541fa82ff055536c8eb402db850caa349674cac1533f73b34fe40e7e7"
    sha256 sonoma:         "f29d945f920b507a8823812eda0553ae0aea07ad9394458082cac94400b203ba"
    sha256 ventura:        "5a83a1e38cae5f21b761c3b26014798654737e59326708315341c3259f8672cb"
    sha256 monterey:       "c92b9be0fd103128718d3847bdd6f64ea58b21e5a05c3a6bfaa27d4904404a46"
    sha256 x86_64_linux:   "8d9983e965cbf4c8f3e0a34476c38691698da05b228d111961fd87207ee4044d"
  end

  depends_on "aarch64-elf-binutils"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

  def install
    target = "aarch64-elf"
    mkdir "aarch64-elf-gcc-build" do
      system "../configure", "--target=#{target}",
                             "--prefix=#{prefix}",
                             "--infodir=#{info}/#{target}",
                             "--disable-nls",
                             "--without-headers",
                             "--with-as=#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-as",
                             "--with-ld=#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-ld",
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
    system "#{bin}/aarch64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-objdump -a test-c.o")
  end
end
