class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.1.tar.xz"
  sha256 "d66df51276143451fcbff464cc8723d68f1e9df45a6a2d5635a54e71643edb80"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 sonoma:       "57922b323fbb136059a16827719005440be39647b9e9f548e8ec6ccfc25620b1"
    sha256 ventura:      "a8dbbcc02d37be4a6b95d1676a14e1ba51190e4a0d0467d2b0c7ff58dd58d4f4"
    sha256 monterey:     "6c954b0c7825b7613432476eb3877a8dad41825a3aa85851da253f70843a03f5"
    sha256 x86_64_linux: "df38b5c447d9f463f6faf88a0905f86a8ec0e9efea8068100497f372d4326f1e"
  end

  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
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
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
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
