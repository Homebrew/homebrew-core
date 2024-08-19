class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "2bcd0a029eaf16495e20dc2bfb4529804f3b2ab867ab1e84157c526a4d107ec0"
    sha256 arm64_ventura:  "7afd2bf73ca5b178481d320611314575d0d4dc7c765c6a15c5a6087ee307ade7"
    sha256 arm64_monterey: "e4e634039978245742b09929d2a96e116e9f6cdac108b1d533c8c9e96aa08b31"
    sha256 sonoma:         "5d13d12951530c9c6a359cc69b4b022d2438072148dc140a70b0d8ac130d3ea4"
    sha256 ventura:        "ef9f05b994a4f41b186d97c4fa12316772b12aa3f6373bbb760cf4b53588ec16"
    sha256 monterey:       "88d86cba855e216dafe7bf21a9fe736c9bbf8e2990e638be7ab8348fa57fee23"
    sha256 x86_64_linux:   "a5af6cda0a3d60aa542e5a4357f85a15df8174ac750a850cbfe83a9c578e85c0"
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
