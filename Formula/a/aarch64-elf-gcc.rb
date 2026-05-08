class Aarch64ElfGcc < Formula
  desc "GNU compiler collection for aarch64-elf"
  homepage "https://gcc.gnu.org"
  url "https://ftpmirror.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gcc/gcc-16.1.0/gcc-16.1.0.tar.xz"
  sha256 "50efb4d94c3397aff3b0d61a5abd748b4dd31d9d3f2ab7be05b171d36a510f79"
  license "GPL-3.0-or-later" => { with: "GCC-exception-3.1" }

  livecheck do
    formula "gcc"
  end

  bottle do
    sha256 arm64_tahoe:   "04ee5f62785fee064c816e87d258df196292332801b76aed09610922bdba0c8d"
    sha256 arm64_sequoia: "4eac3f9cfefd78ae4b70d97b64fa1f86b8109a58d4b1b5c24b7a587bc3166609"
    sha256 arm64_sonoma:  "bd3fe413b667f36c38702e0d381f04ffd530472058e8589bdf81a557a2ce1339"
    sha256 sonoma:        "4ed192d94b0553b18e3b5a1be0782edb4a4e92a8b1b4c95dce952f45b9bf98c3"
    sha256 arm64_linux:   "6660063a88b6e976724a6a0a053a202e14b363603020d3e24bf21e28945ef294"
    sha256 x86_64_linux:  "2deecc76b2f437fb61649894aada202847e8c52d8e76be995f369b0d2ef191f2"
  end

  depends_on "aarch64-elf-binutils"
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
