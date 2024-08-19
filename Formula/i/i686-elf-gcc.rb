class I686ElfGcc < Formula
  desc "GNU compiler collection for i686-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-14.1.0/gcc-14.1.0.tar.xz"
  sha256 "e283c654987afe3de9d8080bc0bd79534b5ca0d681a73a11ff2b5d3767426840"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sonoma:   "286996cd100db5ab8fe89b6c76d77a3c10d978c7f2426f6e1ae79246ed44951a"
    sha256 arm64_ventura:  "6ae8b24a326fa19c41023d3750cd4dd1365afa294f80d04543449c8242887710"
    sha256 arm64_monterey: "3b2a2bf35e2ea64aa356ab0793de01a23d8536715785f793c146457e3a462ca5"
    sha256 sonoma:         "6eb0c8174c52b6b5824047a369135ba7a437deca741d46807f65f999440cefdb"
    sha256 ventura:        "e471f5fb67162666efcab697b8de4fdae8e624a6c560ca43656894db144ff367"
    sha256 monterey:       "7cbe9b4ddeb1052098a4cfe878899e8bf5701bc96334223ed423a48d4a357195"
    sha256 x86_64_linux:   "32aceec99199f28b1d62bc65e20937168f88967b0afeb9a368f34390e808256f"
  end

  depends_on "gmp"
  depends_on "i686-elf-binutils"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

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

    system bin/"i686-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    output = shell_output("#{Formula["i686-elf-binutils"].bin}/i686-elf-objdump -a test-c.o")
    assert_match "file format elf32-i386", output
  end
end
