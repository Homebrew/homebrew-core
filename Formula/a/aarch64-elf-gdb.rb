class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
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
    sha256 arm64_golden_gate: "1d026536c1f3190ad2cbb2188a52e7f0a6e4c1fadccb8e55eb85b548908bc1a6"
    sha256 arm64_tahoe:       "18bc30f8ff350127812bb98aa069a2ee54de2b672666b3aa9571f90adc12ebb2"
    sha256 arm64_sequoia:     "cb23516529e9805cc4904dcf2de3dcb75217f04e544f3ee70f07866f547f36c1"
    sha256 arm64_linux:       "74a348793f7a5067271f276968e9ef47e2d69a237c9e6bae20aa9c46d2e91563"
    sha256 x86_64_linux:      "66519435a689a8adc19f3a12430fdeadfb92151d652c90038ed1df2cbc2f539b"
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "aarch64-elf-gcc" => :test
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

  deny_network_access!

  def install
    target = "aarch64-elf"
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
    system "#{formula_opt_bin("aarch64-elf-gcc")}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
