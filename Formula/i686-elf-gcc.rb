class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-12.2.0/gcc-12.2.0.tar.xz"
  sha256 "e549cf9cf3594a00e27b6589d4322d70e0720cdd213f39beb4181e06926230ff"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_ventura:  "3b676a0e106e44c69919a566ac452c37ddad742ebdb111f66dd2a33e82c6573f"
    sha256 arm64_monterey: "af79fdb341aec9f90a57cea06ef77872b4eb2431d640e6c1bf08dd0c2eeccb34"
    sha256 arm64_big_sur:  "8674a0c791e3698d896723332e75c5ea4beebd613d6aa08e2d96ebd2255c81ad"
    sha256 ventura:        "34cec00f3c016498e89682144e95ceaa7b14703c9b53cee1e59d8c20fb13deae"
    sha256 monterey:       "968383d1b50f229e2368bec33e47fe9cf6a5dd79394d1537799b5d29d096ed7d"
    sha256 big_sur:        "5fc40784f70e7b4cbc58b9f31e5f647cccf0bd0ca0352cae05fdc2a1493ccc5d"
    sha256 catalina:       "c404ebea1c52031768c228d3927fc9966d79d6c0c672e594c04a76191212065b"
    sha256 x86_64_linux:   "6f085b46068e84825c017df037ee53cc0bf66056d9ac3d0da1e8204e1e7b65ea"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"

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
    system "#{bin}/i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf32-i386",
      shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
  end
end
