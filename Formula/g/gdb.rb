class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 arm64_tahoe:   "c01c0cda52e1fad41a91d5e96b0d43788c4f9f5db0dc3d0f9386c923113375c2"
    sha256 arm64_sequoia: "be70c28445f84563eafda28b5316c518da06deabac8ac80fd76f63763a678e58"
    sha256 arm64_sonoma:  "a7532089d35e9dec8375a94400506166aa0bb7b12015c3a8b526769d8856d3a8"
    sha256 sonoma:        "3d316b5a6e0728c4d7dbd18a20301d1a02b759ce1be6558e531a145ad0ca67cd"
    sha256 arm64_linux:   "86b682d7d9f0fd560c4e4222eed1a20374ba6157dcc674500e710b4a9085707b"
    sha256 x86_64_linux:  "502f91d43e75b72251631e85d9dca834edd13f71676df785f3856004ba45a731"
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

  on_linux do
    depends_on "guile"
  end

  def install
    # Fix `error: use of undeclared identifier 'command_style'`
    inreplace "gdb/darwin-nat.c", "#include \"cli/cli-cmds.h\"",
                                  "#include \"cli/cli-cmds.h\"\n#include \"cli/cli-style.h\""

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
