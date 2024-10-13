class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.2.0/gcc-14.2.0.tar.xz"
  sha256 "a7b39bc69cbf9e25826c5a60ab26477001f7c08d85cec04bc0e29cabed6f3cc9"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia:  "02ee0b32bbabf4dcdc9de814962bb5b6ce09df637cc3ae766e7381a828d8ad8d"
    sha256 arm64_sonoma:   "aca4e725e01b8ac1d402b4fea24c8b73c0ac314e7f8d5c55d9270b65f4c7e9a2"
    sha256 arm64_ventura:  "6855ca2ac193077156d6e45c06f5aea30eb600479788617958af06c2e5a65cc7"
    sha256 arm64_monterey: "80d990bad766cb840bfee1dbc5ce1f0fd3ab95c5bd73111a0d7de9b1c99a996a"
    sha256 sonoma:         "35a213484c8c13848265038047c6dce9c75e0f43f3f81a51c4992ecd39e86a16"
    sha256 ventura:        "8be78df605ae82c4d9d45ebb1b880be86ee454abbc3f253dd5e84ae285c8eabf"
    sha256 monterey:       "4b557fe0dafb9b107bb1674e53339f1ec0548dea349aae46f218eca9b75890b5"
    sha256 x86_64_linux:   "b20b3f72772560c778e8737601d13fa1062a3de125fbb7603fbe114c2c87eb73"
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
    system bin/"aarch64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-objdump -a test-c.o")
  end
end
