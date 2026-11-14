class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gdb/gdb-18.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-18.1.tar.xz"
  sha256 "cd9fc3fe2b47743840e42c1592d3d87f8302eb18639c0b8b4ba0898002e2348f"
  license "GPL-3.0-or-later"
  revision 1
  compatibility_version 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 arm64_golden_gate: "8dee7b8cc7eee80d35988b2ae17291083b8fd951209cb4f60afc9a4cfa8d3ceb"
    sha256 arm64_tahoe:       "c616c89bff1382d9481cb51f8e3737f91684f7b9efd184eae0f4fc71749e6f7f"
    sha256 arm64_sequoia:     "5ef8f3a5486ae4343d5ed0993d6a3b30f2b12899bdf94c73e522011528e6e097"
    sha256 arm64_linux:       "4d9ed2a1b243b7b634b5170235cf8ee05a74f9f8718ea0014ce9d6c56e98fc86"
    sha256 x86_64_linux:      "06dacef657717e6ee286ef592c41d618a25ad31637f5dcb3b5e86af3bb1efcd4"
  end

  depends_on "pkgconf" => :build
  depends_on "texinfo" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.15"
  depends_on "readline"
  depends_on "xz" # required for lzma support
  depends_on "zstd"

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"

  on_linux do
    depends_on "guile"
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
    # Fix `error: use of undeclared identifier 'startup_with_shell'`
    inreplace "gdb/darwin-nat.c", "#include \"inferior.h\"",
                                  "#include \"inferior.h\"\n#include \"gdbsupport/common-inferior.h\""

    args = %W[
      --enable-targets=all
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

    # Fix: Apple Silicon build, this is only way to build native GDB
    if OS.mac? && Hardware::CPU.arm?
      # Workaround: "--target" must be "faked"
      args << "--target=x86_64-apple-darwin20"
      args << "--program-prefix="
    end

    mkdir "build" do
      system "../configure", *args, *std_configure_args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb", "maybe-install-gdbserver"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        gdb requires special privileges to access Mach ports.
        You will need to codesign the binary. For instructions, see:

          https://sourceware.org/gdb/wiki/PermissionsDarwin
      EOS
    end
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
