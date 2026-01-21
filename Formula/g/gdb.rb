class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gnu/gdb/gdb-17.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-17.1.tar.xz"
  sha256 "14996f5f74c9f68f5a543fdc45bca7800207f91f92aeea6c2e791822c7c6d876"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:   "0a8a0ca274f7d119562044d9a3a7002c8b31a9103202b60e706ee1daed4a555a"
    sha256 arm64_sequoia: "2a4e4dad528731ac3f73f1b256d721ef1a42e4108db79e983cee79544b89fa26"
    sha256 arm64_sonoma:  "9ed402d364e859b1f3a5df659e51b59c9be6936dc4d634fed0ea67be1cdd8319"
    sha256 sonoma:        "2b9027648d7f6ea38505fdadad50ba628115970a47a65b81274f13a451aea35f"
    sha256 arm64_linux:   "6289743986eb0f3a00515faa95f716f39943197ba16a720702bd84f836c112ce"
    sha256 x86_64_linux:  "49479941452f597d54bf01f710ad6c1abf8fc28a20c42adc3882e591517213b0"
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
