class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-15.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-15.1.tar.xz"
  sha256 "38254eacd4572134bca9c5a5aa4d4ca564cbbd30c369d881f733fb6b903354f2"
  license "GPL-3.0-or-later"
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 sonoma:       "0bbcc58f6570f60b7a077157fbce8f838a5b6320298e6220f3bd89dd86d9d508"
    sha256 ventura:      "4f70690e1f132c66629f14092ac8dcd9fc65583e6ed31afb009ee982be47df46"
    sha256 monterey:     "6e77121eddb5bf69cdd731aa9375ea55916aa26e159c81a3da47dc19e6811bde"
    sha256 x86_64_linux: "dd11325ca2297ad1be34eb940e64c3be5522e491daae7460e5b1b3ac63842206"
  end

  depends_on "gmp"
  depends_on "mpfr"
  depends_on "python@3.12"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  on_macos do
    depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  end

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
