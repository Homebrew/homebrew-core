class ArmNoneEabiGdb < Formula
  desc "GNU debugger for arm-none-eabi cross development"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-17.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-17.2.tar.xz"
  sha256 "1c036c0d72e4b3d1fb5c94c88632add6f9d76f4d7c4d2ea793c12a9f19a3228c"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  livecheck do
    formula "gdb"
  end

  bottle do
    sha256 arm64_tahoe:   "19ff195ba43db782e3372141e75cd917c9a809616f7d8fdc7a8ad8559bc8d8d4"
    sha256 arm64_sequoia: "2c65dcacf5b6c19079287f80d14ab3be2331dd77240fccf6a13838df240f26d0"
    sha256 arm64_sonoma:  "b3270d6dfee7ba828fd39f6e7b2347a554c37cceafecf9d8d3fb573e452cb795"
    sha256 sonoma:        "b234e1006af9ea544524938cc6036419df58a7123f2c444ee12b9f6aaad44d21"
    sha256 arm64_linux:   "03e8f7a7b814ab6026058b33c9604a0b762e67d342dde2c28acc65aa64eee791"
    sha256 x86_64_linux:  "2c8bc28b9e200aa0f03bbf6875b731ff8a34c75a9cdcef1bce0b63423c593ffd"
  end

  depends_on "pkgconf" => :build
  depends_on "arm-none-eabi-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.14"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python

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
      --with-python=#{which("python3.14")}
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
    system "#{Formula["arm-none-eabi-gcc"].bin}/arm-none-eabi-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/arm-none-eabi-gdb -batch -ex 'info address _start' a.out")
  end
end
