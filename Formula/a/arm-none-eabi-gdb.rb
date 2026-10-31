class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
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
    sha256 arm64_golden_gate: "2320ab678e7e144c1a6044ce875f201fad9d09e3178446d72435094f77f1d9de"
    sha256 arm64_tahoe:       "67fce6a2642eed6e634b1c81cab770c3ceee8484aa8d678f37089ac6948d442c"
    sha256 arm64_sequoia:     "8842d13fad824a04177373ec80ff5f2c4f64f8d7890ab6d9353a00d806ec6650"
    sha256 arm64_linux:       "f2735f9c9b6e491e9fda17607e6c7a6355a512085d6b19e05b117760a0d9ed0e"
    sha256 x86_64_linux:      "2e8768e1e1120420dacd79c8d2b143418e785a4ee1c2164f75448065136cf23e"
  end

  depends_on "pkgconf" => :build
  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.15"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"

  # Workaround for https://github.com/Homebrew/brew/issues/19315
  on_sequoia :or_newer do
    on_intel do
      depends_on "expat"
    end
  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

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

  deny_network_access!

  def install
    target = "arm-none-eabi"
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
    system "#{formula_opt_bin("arm-none-eabi-gcc")}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end
