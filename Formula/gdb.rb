class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-12.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-12.1.tar.xz"
  sha256 "0e1793bf8f2b54d53f46dea84ccfd446f48f81b297b28c4f7fc017b818d69fed"
  license "GPL-3.0-or-later"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git", branch: "master"

  bottle do
    sha256 monterey:     "b01f3958cc295ef0b3a270ddcddfdbca79dd09c7df08175a84d687af11c3d458"
    sha256 big_sur:      "00b147895f10aa3a21f394f347fb6b360027f1088581cda4bd82e551cf0ae0e0"
    sha256 catalina:     "39b4bc0defa847236aaed8ada0e4bcbe6a2e4f0c7de18a844cf6a018568433f9"
    sha256 x86_64_linux: "5e0713b32a6becb1a12ee508269563fc6ae1fa8d0698d9f03b6c7fa4470f4bc4"
  end

  depends_on arch: :x86_64 # gdb is not supported on macOS ARM
  depends_on "gmp"
  depends_on "python@3.10"
  depends_on "xz" # required for lzma support

  uses_from_macos "texinfo" => :build
  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

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
      --with-python=#{Formula["python@3.10"].opt_bin}/python3.10
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
    <<~EOS
      gdb requires special privileges to access Mach ports.
      You will need to codesign the binary. For instructions, see:

        https://sourceware.org/gdb/wiki/PermissionsDarwin
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
