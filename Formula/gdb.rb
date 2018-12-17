class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.2.tar.xz"
  sha256 "c3a441a29c7c89720b734e5a9c6289c0a06be7e0c76ef538f7bbcef389347c39"
  revision 1

  bottle do
    sha256 "494641bdd92ccbf9a998943a1ffbdbf77e1970c9234a726727788dacbbf925c0" => :mojave
    sha256 "61f97b09fa467416772bb972aafc95bd69aed211c741787cbe13885e115701c3" => :high_sierra
    sha256 "5d35ee00715d9f119d90222e57c84f9173e3d2665af947b00fe189e7c01e4429" => :sierra
  end

  depends_on "pkg-config" => :build

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  fails_with :clang do
    build 600
    cause <<~EOS
      clang: error: unable to execute command: Segmentation fault: 11
      Test done on: Apple LLVM version 6.0 (clang-600.0.56) (based on LLVM 3.5svn)
    EOS
  end

  # Fix build with all targets. Remove if 8.2.1+
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commitdiff;h=0c0a40e0abb9f1a584330a1911ad06b3686e5361
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d457e55/gdb/all-targets.diff"
    sha256 "1cb8a1b8c4b4833212e16ba8cfbe620843aba0cba0f5111c2728c3314e10d8fd"
  end

  # Fix debugging of executables of Xcode 10 and later
  # created for 10.14 and newer versions of macOS. Remove if 8.2.1+
  # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=fc7b364aba41819a5d74ae0ac69f050af282d057
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/d457e55/gdb/mojave.diff"
    sha256 "6264c71b57a0d5d4aed11430d352b03639370b7d36a5b520e189a6a1f105e383"
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-targets=all
      --with-python=/usr
    ]

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    inreplace ["bfd/Makefile", "opcodes/Makefile"], /^install:/, "dontinstall:"

    system "make", "install"
  end

  def caveats; <<~EOS
    gdb requires special privileges to access Mach ports.
    You will need to codesign the binary. For instructions, see:

      https://sourceware.org/gdb/wiki/BuildingOnDarwin

    On 10.12 (Sierra) or later with SIP, you need to run this:

      echo "set startup-with-shell off" >> ~/.gdbinit
  EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
