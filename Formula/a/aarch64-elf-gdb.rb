class Aarch64ElfGdb < Formula
  desc "GNU debugger for aarch64-elf cross development"
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
    sha256 arm64_tahoe:   "c958dd17cd4589be2776d5dc2ea42407e97e8e8fa6144ab6e557715644c700be"
    sha256 arm64_sequoia: "ed517cad598f41182e050ebb66bcc10249b520ebb283de167b8b4ef28df9d6fb"
    sha256 arm64_sonoma:  "b36350487f63d82dfb9f8e73d7d61b92ef10f671ebf1d03040897783a7fe5060"
    sha256 sonoma:        "a34575014e49cba4ab7744a4318e523906ea3d99ab93b6dd850375102484989e"
    sha256 arm64_linux:   "2b1f5ab9b9c1d88d884c5c1ede27c64995e093fc1e785608dbcee33a9f893bbb"
    sha256 x86_64_linux:  "f5093f7b253715bb6a7df45f63f3c491774e7fcd74d79e9fc23c8cfe45aeabf8"
  end

  depends_on "pkgconf" => :build
  depends_on "aarch64-elf-gcc" => :test
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
    system "#{Formula["aarch64-elf-gcc"].bin}/aarch64-elf-gcc", "-g", "-nostdlib", "test.c"
    assert_match "Symbol \"_start\" is a function at address 0x",
          shell_output("#{bin}/aarch64-elf-gdb -batch -ex 'info address _start' a.out")
  end
end
