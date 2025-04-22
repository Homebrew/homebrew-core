class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.3.tar.xz"
  sha256 "bcfcd095528a987917acf9fff3f1672181694926cc18d609c99d0042c00224c5"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "9e5f18aa75cef9f236a7f07d4e444d54a8cccf3ff7e119f9923db8bef62d1252"
    sha256 arm64_sonoma:  "06baf22991ec402640b1d6d886e3218d208abd368e8ba50c2116b17923f633ae"
    sha256 arm64_ventura: "b0d0fc6a961b484803767ee5a1ba108de2a61e06522236536c7e600ea1d541cc"
    sha256 sonoma:        "1f09c138f3bdeaf1066dc83fe96e6c6a9bdab4e1a73553048606708c84fc5d70"
    sha256 ventura:       "1f477ff41885a15a223c3c17931e4f8cd530262f3c7286969028af78dfa8e8bf"
    sha256 arm64_linux:   "bdc566b8b01f046ce432ed7445f7a9ff929f155bf48643288362b78340239bb3"
    sha256 x86_64_linux:  "5dce623e116162d2edb8668a5f5b5085dea0b0dbce8b245985de933ed0079097"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat", since: :sequoia # minimum macOS due to python
  uses_from_macos "ncurses"
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
    depends_on "pkgconf" => :build
    depends_on "guile"
  end

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  def install
    # Fix `error: use of undeclared identifier 'command_style'`
    inreplace "gdb/darwin-nat.c", "#include \"cli/cli-cmds.h\"",
                                  "#include \"cli/cli-cmds.h\"\n#include \"cli/cli-style.h\""

    args = %W[
      --enable-targets=all
      --with-lzma
      --with-python=#{which("python3.13")}
      --disable-binutils
      --with-system-zlib
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
