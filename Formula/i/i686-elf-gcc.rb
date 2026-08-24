class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.2.0/gcc-16.2.0.tar.xz"
  sha256 "e6738e29597f733270731aa90600f37ffdc045079dfc27ec7e8192cc81085c3e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "06ac3ad32b5a3354f93081c71b69d196bb870b675eb673366f7fb1ca1bc2da6a"
    sha256 arm64_sequoia: "07a994743beac9bb814bfdd9e6f7610706950087520d01bdac77ca49fa695ed3"
    sha256 arm64_sonoma:  "d5a9c48ac336c523f059c7c2e35742cab925f091c4b5f472287dd130c6861b70"
    sha256 sonoma:        "9da81e96a037ecf4c5d0e080986b3fc235c84931007e36e871c4352795fbbac4"
    sha256 arm64_linux:   "4736ca9cb03afb5786a35c8b515af3d10b37af80aa725a4b5306afb358469eb7"
    sha256 x86_64_linux:  "3e05ece5c7d5db47eb20d4fe9b95fd794f467c1980ddcd4825654f4dea3e1a11"
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
