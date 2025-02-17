class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.2.tar.xz"
  sha256 "4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "59ce7ab783da5490d59be3a7cc1ebb048711501e91a7fb43365a99c4ca62c4c3"
    sha256 arm64_sonoma:  "5e892bdad375fccc5b950692d917b3b9b1cbea713a5845ea00a6450b3e137ae8"
    sha256 arm64_ventura: "bc1098d808117951a4944c9e66c8161725f6a0d230c188074708c311bbb4c4a7"
    sha256 sonoma:        "bd1fe9eca3dd9c00f938887815f55acd158beef0208ae573350ac9ccd1754d0e"
    sha256 ventura:       "485a217eb5c5798d6b1182eee07449c993809f40afa37c143192e9fdb81d9129"
    sha256 x86_64_linux:  "997e66c3b98bb1ae9612bd4d4ce6b60c4384cd821e9e0265a6088381a0913c10"
  end

  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
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
      --with-python=#{which("python3.13")}
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
