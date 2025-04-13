class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-16.2.tar.xz"
  sha256 "4002cb7f23f45c37c790536a13a720942ce4be0402d929c9085e92f10d480119"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    rebuild 2
    sha256 arm64_sequoia: "e19f455ea5aed064e4d91c6a1aff73f1ce2d7183c188dc48c587d0cc35fc3d61"
    sha256 arm64_sonoma:  "dd538bad2a1415e5ddfedf6b3b466871d9abbe17ee880dc34425f80b03616360"
    sha256 arm64_ventura: "21a37a8e18f1974a8342e9fd0b089829b7ce17b93c75300d8b25def54a681638"
    sha256 sonoma:        "b20978682d45b707576385b6f28bb51e7e5400e2e1b885ebcef52ba5e9823c2a"
    sha256 ventura:       "583530e65b7112358a1d4b8d200b597bb348e91863c51cdc7eea515f83e0be7d"
    sha256 arm64_linux:   "8be5b619c9bb8c729cb9947601f2dcafddccf3516d54baa9acae312da9018d67"
    sha256 x86_64_linux:  "90ef1f376c0cf3534e765206a918d294129598b0953ab6a983371b0ebc0f0ed7"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.13"
  depends_on "xz" # required for lzma support

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
