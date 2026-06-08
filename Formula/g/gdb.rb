class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-17.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-17.2.tar.xz"
  sha256 "1c036c0d72e4b3d1fb5c94c88632add6f9d76f4d7c4d2ea793c12a9f19a3228c"
  license "GPL-3.0-or-later"
  compatibility_version 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 arm64_tahoe:   "12341ca6f6b31162ec70586e0772257dae2fa2840a4081efd30af0c604379db7"
    sha256 arm64_sequoia: "2feabbafc0fa519392852f4c683ac1f2ec77bfb206b8759c5d58a65aceca0a37"
    sha256 arm64_sonoma:  "751ed85d1945ff8fd0892fda21fd0dd38a70138cb5ed8fda5c822ab90bacb6b1"
    sha256 sonoma:        "c4ca53440086795fdb0ea5eb8609f278c412962259e4f02c0a27feb3d1151354"
    sha256 arm64_linux:   "2c2b33885fd81a54aedf65f3783bca5b1ace11dff3824c6a738ccd2b0a5facfe"
    sha256 x86_64_linux:  "1cd209394e560c53f14c50407459f242f1095e440fcff1bc4b456cac9aad8f8b"
  end

  depends_on "pkgconf" => :build
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
    depends_on "guile"
    depends_on "zlib-ng-compat"
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
      --with-python=#{which("python3.14")}
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
