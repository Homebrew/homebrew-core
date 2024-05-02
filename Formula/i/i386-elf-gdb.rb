class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.2.tar.xz"
  sha256 "2d4dd8061d8ded12b6c63f55e45344881e8226105f4d2a9b234040efa5ce7772"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sonoma:   "3ada87a84bb52d584881f785be85a27d62e61bdeb205ffb0636a015aa8ffd0ef"
    sha256 arm64_ventura:  "2823a909bcb2690ceb44f86a578028e1056b954a755f3f7d3ca831c0416caad7"
    sha256 arm64_monterey: "faed2b54ed55aceff38af30599985589dbba414cb5139bfb6878a91fc3685935"
    sha256 sonoma:         "b478c9a08378b542c5febada80bc13be5d26755cf1640a37a0eefeb1c8edc60b"
    sha256 ventura:        "37766cbf0f336352a604124e4658d835184fec4c67b248587380f5440b5c34b3"
    sha256 monterey:       "caf010b58f2d7fe989f8098b928b94335abae251b02ca959786bee5008ef169d"
    sha256 x86_64_linux:   "c30326ac88489c32ae487569b81b36c10483929008c62cd862b67091a6ff1e76"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

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
    assert_match "Symbol \"_start\" is a function at address 0x",
                 shell_output("#{bin}/i386-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
