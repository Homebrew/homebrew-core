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
    sha256 arm64_tahoe:   "92a7103601dc0c37db13ed93343b4671665c46e8ddd9f254ba697ad744eb9c8c"
    sha256 arm64_sequoia: "47c0d0ced3dd45b08d524e79c6bbb260aaaefa9f1b3c7b9125aca936ca7d8b6c"
    sha256 arm64_sonoma:  "70af1c1ff0e2fe89bd5a48fcd474b7e20f5b8beaba7c0cab685abfd575abbdb9"
    sha256 arm64_ventura: "ea891b743bfa1d20750b0bf3a6d42d26a75735e2915db2274aeeba005741af7c"
    sha256 sonoma:        "ffaedf2d455c5355e38e12bb6e7cb6e48461207645b645de0d63c4a7cd21eaa1"
    sha256 ventura:       "f2afbcf4b04dd28df9aa429637246aba842181c85a7e926c1ece700695a41d3a"
    sha256 arm64_linux:   "68de611434d96d73eeb8428e02b7c9d66b4bae87ce814a6d49a2a171d6c517b4"
    sha256 x86_64_linux:  "7fe586dbc32997229e4454d233077b94563d2a36802a5c2b608bd7edcd9e00c0"
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
