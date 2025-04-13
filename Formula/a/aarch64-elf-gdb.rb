class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.2.tar.xz"
  sha256 "4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_sequoia: "324a6c319ea8a9d175e6327d89593fc9eea7d1fbe484d41533479f5b1795b3a8"
    sha256 arm64_sonoma:  "9a79fc135975687ba9f0ec19696895f6df8c0ba831930e3abf66bc9814f49a4b"
    sha256 arm64_ventura: "5c1056bf8a6b599855947d3c449e43f439c0367dd0e9a2a2d7501e039f69e250"
    sha256 sonoma:        "07d44f785b149db031e9b6f9c65ab4bc96bad7cf348c047e7023f8b8618d3026"
    sha256 ventura:       "96bc5b3fa085b1ca452460f1619eeef4c1a9109616e5f0d5891d36aeb9682a7c"
    sha256 arm64_linux:   "97ac90c8694702eb0699084ef28711c7969f41cc6459dc34371c08dba5509d00"
    sha256 x86_64_linux:  "b424c1bce12d07f93a06767ea48703bdcf10a6bcba460b1ef4b4b99a4c3c36cf"
  end

  depends_on "pkgconf" => :build
  depends_on "aarch64-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  def install
    target = "aarch64-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --enable-tui
      --with-curses
      --with-expat
      --with-lzma
      --with-python=#{which("python3.13")}
      --with-system-readline
      --with-system-zlib
      --with-zstd
      --disable-binutils
      --disable-nls
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
    system "#{Formula["aarch64-elf-gcc"].bin}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
