class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "8e2c4ad88cbeb24b8de4bd588b2295594282738e750a12257b741d62b9554d15"
    sha256 arm64_sonoma:  "d76a7ca2b5c17dfd8371073bd9403eebbf767778cd29b3b12add0906f1c292c7"
    sha256 arm64_ventura: "4c06228afceb027d0ce4b34256c6ec0d5cd7dfe7daeec3ed9294cfc30530bd1a"
    sha256 sonoma:        "1172380d92d25c59e015a58d537e7034ba29bfaf6fe8144100744074829a0ff4"
    sha256 ventura:       "8a8386bf395ef25bea60ec676e54579ffa3a7f36e9c5559e3f4be9840ad9ff7e"
    sha256 arm64_linux:   "7dea4d76dd9a20c6f789b0b942843995bbc12cf73f55345e54c3ebd2b986e043"
    sha256 x86_64_linux:  "311f32728f01c2ee43cc703ed6a12be6b930a0df5f434f4ffeda5bf9e8f2aedc"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  uses_from_macos "zlib"

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
