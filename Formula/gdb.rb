class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-12.1.tar.xz"
  sha256 "0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed"
  license "GPL-3.0-or-later"
  revision 2
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    rebuild 2
    sha256 monterey:     "65cd5bfb98728c3942649345c0b1b7e9b12ef0bf1c16e480c345d169d2ed8ee8"
    sha256 big_sur:      "9fbb9e2444a2be881b7f4263a00ef43c60c6f4044b2d601c82a8d73d48b8aed0"
    sha256 catalina:     "dd505a4d90fe6148cf312e951746c779acb6bcfa7b39c4e400eece40021aeb60"
    sha256 x86_64_linux: "72b4cec34b86c1f3b5945a49e22cc27e23f00140bdc7c776c142ae250ac55efb"
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
