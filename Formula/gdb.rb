class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-13.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-13.1.tar.xz"
  sha256 "115ad5c18d69a6be2ab15882d365dda2a2211c14f480b3502c6eba576e2e95a0"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 ventura:      "de9efad28231614ea8281c5e56c0c844634401924fb152f2dd21d578323b3235"
    sha256 monterey:     "4055ffb959df163d0557d6152b8544d91476b0e8957f6917b7a0d7d5c782e769"
    sha256 big_sur:      "6d5b7c84aaf8ec02686118657f435434b453fd7e144c6cdabdcb294cc97ce637"
    sha256 x86_64_linux: "2d110ae74b24058c5d721156006dca2c52559a1480f186254324430bb6e689cf"
  end

  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "gmp"
  depends_on "python@3.11"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "guile"
  end

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  fails_with gcc: "5"

  def install
    args = %W[
      --enable-targets=all
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.11"].opt_bin}/python3.11
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
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
