class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftp.gnu.org/gnu/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  mirror "https://ftpmirror.gnu.org/gcc/gcc-15.1.0/gcc-15.1.0.tar.xz"
  sha256 "e2b09ec21660f01fecffb715e0120265216943f038d0e48a9868713e54f06cea"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_sequoia: "2775914b08cd4cb33eb23aa380ed5d5ec3044ff654978b5e5a5d3410aba267a8"
    sha256 arm64_sonoma:  "ea7af2549d31919b0cae18067e4e3e6804ff52b1135a84f7a21f0da3130ecb26"
    sha256 arm64_ventura: "2764387f82ee47f63134da77db38050dea5e1c2c44bb60d3acea9a03c7beaec2"
    sha256 sonoma:        "efd8112ddb6777583c4af5abc2cc9ea192cde2bad02e60e84e420d830803e369"
    sha256 ventura:       "ddda9fcf0d64276c5cb34493ffcda10f76c43daef986a959cd6799f6c9d1a152"
    sha256 arm64_linux:   "8e63a1b5044f6649d568113ca763cc890540d3e94bb3be9151b918a1e0d3b7f1"
    sha256 x86_64_linux:  "fd7dea08552fe7b3f9405632d1f29c3e0dc07010a895ab22ed4a7401879ec795"
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
    (testpath/"test-c.c").write <<~C
      int main(void)
      {
        int i=0;
        while(i<10) i++;
        return i;
      }
    C
    system bin/"aarch64-elf-gcc", "-c", "-o", "test-c.o", "test-c.c"
    assert_match "file format elf64-littleaarch64",
                 shell_output("#{Formula["aarch64-elf-binutils"].bin}/aarch64-elf-objdump -a test-c.o")
  end
end
