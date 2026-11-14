class I386ElfGdb < Formula
  desc "GNU debugger for i386-elf cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gdb/gdb-18.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-18.1.tar.xz"
  sha256 "cd9fc3fe2b47743840e42c1592d3d87f8302eb18639c0b8b4ba0898002e2348f"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    rebuild 2
    sha256 arm64_golden_gate: "a922484692da27abbe570a4e6b0cf489c1896322e4fa5707b9d87939b4430f63"
    sha256 arm64_tahoe:       "98176f08a40d03a835ce9eb9ff3895bb79d8bd34cb093a3bba00136bd430cd3e"
    sha256 arm64_sequoia:     "a71c5e0caf5072501052f80fe75f471a4d1d5790d4107aaab7db028ea3e32ac1"
    sha256 arm64_linux:       "99af715befc113fa11e4ba4fc9aa4b1c2004f23b6114e863ad348367a58a8ff9"
    sha256 x86_64_linux:      "51e31d01b71c381ca4baece52fedb199b6faed48bc8276be0542f782b25e36cd"
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.15"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Work around `mvwaddstr` and `mvwaddnstr` in macOS ncurses writing nothing,
  # which leaves TUI windows such as `layout regs` empty
  patch do
    file "Patches/gdb/macos-system-ncurses.patch"
    type :unofficial
    resolves "https://github.com/Homebrew/homebrew-core/issues/224294"
  end

  def install
    target = "i386-elf"
    args = %W[
      --target=#{target}
      --datarootdir=#{share}/#{target}
      --includedir=#{include}/#{target}
      --infodir=#{info}/#{target}
      --mandir=#{man}
      --disable-binutils
      --disable-nls
      --enable-tui
      --with-curses
      --with-expat
      --with-lzma
      --with-python=#{python3}
      --with-system-readline
      --with-system-zlib
      --with-zstd
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
    system formula_opt_bin("i686-elf-gcc")/"i686-elf-gcc", "-g", "-nostdlib", "test.c"

    # `--cd` sets gdb's working directory without `getcwd`, which the Linux sandbox denies
    output = shell_output("#{bin}/i386-elf-gdb -batch --cd=#{testpath} -ex 'info address _start' a.out")
    assert_match "Symbol \"_start\" is a function at address 0x", output
  end
end
