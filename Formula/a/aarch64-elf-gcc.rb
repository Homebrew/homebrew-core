class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-15.2.0/gcc-15.2.0.tar.xz"
  sha256 "438fd996826b0c82485a29da03a72d71d6e3541a83ec702df4271f6fe025d24e"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "6b143ee35830f3cafa970d17d063cc1ca6c9ddd1e0e8be53fc9c736cb6b093b0"
    sha256 arm64_sequoia: "84c76461cca4e1e88ca11ab1a25319f3688d8b8687c18de0131f970fdbcf9cc3"
    sha256 arm64_sonoma:  "30169f8be9da11b9da508bb9149035e79decf4acfe85e7073e79220a8d7cc3f0"
    sha256 arm64_ventura: "b1ce1405c117b7af21c7f3d7aae0d09fc461a736133c7893f162d74e523177f8"
    sha256 sonoma:        "ba627e18b1d928e4df9a05c7e865f2e99ebdf58413a771323036d828091f8e68"
    sha256 ventura:       "72262b703d74775bf3f319aaadab659322f7c94f1b83210fa1ce4d31bf21f35b"
    sha256 arm64_linux:   "6575f0e5e5408f293992aa5e0f728c2d902411cab9c0f1310152ee732314e429"
    sha256 x86_64_linux:  "1a04adeee3439a7bb9c9cc881853f1445697531304ab3a42f9e2d127ca398ff1"
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
