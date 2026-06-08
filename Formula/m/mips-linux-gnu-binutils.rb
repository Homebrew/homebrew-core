class MipsLinuxGnuBinutils < Formula
  desc "GNU Binutils for mips-linux-gnu cross development"
  homepage "https://www.gnu.org/software/binutils/"
  url "https://ftpmirror.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  mirror "https://ftp.gnu.org/gnu/binutils/binutils-2.46.0.tar.bz2"
  sha256 "0f3152632a2a9ce066f20963e9bb40af7cf85b9b6c409ed892fd0676e84ecd12"
  license "GPL-3.0-or-later"

  livecheck do
    formula "binutils"
  end

  bottle do
    sha256 arm64_tahoe:   "72553adf10ac56e7b1c156a95e9380c1f773ee7663541000b16b022e1b91047a"
    sha256 arm64_sequoia: "37baeba89172e648c28d3ac8b66a358ecfc4aeb0fd720ef80373b65d6fade6e9"
    sha256 arm64_sonoma:  "8fbd5036eaca53faa4aa861014150b3de45c94763a70902403b93fb975740754"
    sha256 sonoma:        "1bf4c7d5473226b95f23213133a08cfc49650c6b125ba34cba72db54ca7348ec"
    sha256 arm64_linux:   "7752b1c6416cb908aaf4da02a3b5c3119fc6ead163412b0bfa66cdfbafa41421"
    sha256 x86_64_linux:  "b8f26462bce7297a772b7252f232051a236b9ded74bc92defa3ea3ce3703e9bf"
  end

  depends_on "pkgconf" => :build
  depends_on "zstd"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    target = "mips-linux-gnu"
    system "./configure", "--target=#{target}",
                          "--infodir=#{info}/#{target}",
                          "--with-system-zlib",
                          "--with-zstd",
                          "--disable-nls",
                          *std_configure_args(libdir: lib/"target")
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test-s.s").write <<~ASM
      .section .text, "ax"
      .set noat
      .globl _start
      _start:
          addiu $v0, $zero, 0
          j $ra
    ASM

    system bin/"mips-linux-gnu-as", "-o", "test-s.o", "test-s.s"
    assert_match "file format elf32-tradbigmips",
                 shell_output("#{bin}/mips-linux-gnu-objdump -a test-s.o")
    assert_match "f()", shell_output("#{bin}/mips-linux-gnu-c++filt _Z1fv")
  end
end
