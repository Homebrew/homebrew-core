class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-14.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-14.2.tar.xz"
  sha256 "2d4dd8061d8ded12b6c63f55e45344881e8226105f4d2a9b234040efa5ce7772"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 sonoma:       "ee07ec8292ea65493971dc8ab7d65380efdade32c86cd487f55275ba6b182b2c"
    sha256 ventura:      "c2a54fa9c09eddf858d2f7f1c5e7e1ad09473d8fb9daf0f695d828395cb69147"
    sha256 monterey:     "cafd2299a0070a912dd89a9cbccad0696a0be70b8d8784200d29d74da2d356b8"
    sha256 x86_64_linux: "e9bd1f639ec4732d1ced581f9eee17194da161f200b0b2c055f64476db60de64"
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
      --with-lzma
      --with-python=#{Formula["python@3.12"].opt_bin}/python3.12
      --disable-binutils
    ]

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
