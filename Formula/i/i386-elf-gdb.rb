class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.1.tar.xz"
  sha256 "38254eacd4572134bca9c5a5aa4d4ca564cbbd30c369d881f733fb6b903354f2"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "f23d46b347becb5885f78a4ada3aefb47ba32d595e980e00250ac12083941250"
    sha256 arm64_ventura:  "5e0ae19737a7a7b3ecadb2502f192c44399efe642add40d19139cc407c4a98fe"
    sha256 arm64_monterey: "ea2e6be08a6452eb2c1e28877e01009c8f8997376d3c32c14615ca8c88c5f598"
    sha256 sonoma:         "a06e3267f25adeebeec1270a1bbe46c807f7ba052f31c95ad0aa598aef2ab35a"
    sha256 ventura:        "d64aa7d5e66b4efb52e96aa85eb69263110078d105b54ed2feaa890f91d8eb35"
    sha256 monterey:       "b244991b18043c406a0e61ffdb992127984c56ac937ce262e64d677af513e0fa"
    sha256 x86_64_linux:   "3bb7816e229e35895731d884cad604080ffa61ff64defcacf24948d435a253c5"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "i386-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --with-lzma
      --with-python=#{which("python3.12")}
      --with-system-zlib
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      ENV.deparallelize # Error: common/version.c-stamp.tmp: No such file or directory
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  test do
    (testpath/"test.c").write "void _start(void) {}"
    system Formula["i686-elf-gcc"].bin/"i686-elf-gcc", "-g", "-nostdlib", "test.c"

    output = shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
