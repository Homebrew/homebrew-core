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
    rebuild 1
    sha256 arm64_golden_gate: "b79f61a8232cd4b91a7138878f2d8f903d0f7d3993e1394130930b75b1bbbb93"
    sha256 arm64_tahoe:       "7faf826fdb7c0fcfd6cc7fad9ae013dc9f1d42a92fd4872b0fb21c8aa156e77a"
    sha256 arm64_sequoia:     "2d25ffc1eba3ecae47f37b71b049dc8ee9bc3208a8e60a4b0d9a701457118fc1"
    sha256 arm64_linux:       "6b065e9d9a1d21c42c791fd6b8d214bc552809b9bde46210213dcfad54cb6345"
    sha256 x86_64_linux:      "8da7b5ff0dea9c32a3e95cdbce1cee8a00ea0baaca1acd250797577e663f3296"
  end

  depends_on "pkgconf" => :build
  depends_on "i686-elf-gcc" => :test
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "ncurses" # https://github.com/Homebrew/homebrew-core/issues/224294
  depends_on "python@3.15"
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
