class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  head "https://sourceware.org/git/binutils-gdb.git"

  stable do
    url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.1.tar.xz"
    mirror "https://ftpmirror.gnu.org/gdb/gdb-8.2.1.tar.xz"
    sha256 "0a6a432907a03c5c8eaad3c3cffd50c00a40c3a5e3c4039440624bae703f2202"

    # Fix build with all targets. Remove for 8.3
    # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;a=commitdiff;h=0c0a40e0abb9f1a584330a1911ad06b3686e5361
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d457e55/gdb/all-targets.diff"
      sha256 "1cb8a1b8c4b4833212e16ba8cfbe620843aba0cba0f5111c2728c3314e10d8fd"
    end

    # Fix debugging of executables of Xcode 10 and later
    # created for 10.14 and newer versions of macOS. Remove for 8.3
    # https://sourceware.org/git/gitweb.cgi?p=binutils-gdb.git;h=fc7b364aba41819a5d74ae0ac69f050af282d057
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/d457e55/gdb/mojave.diff"
      sha256 "6264c71b57a0d5d4aed11430d352b03639370b7d36a5b520e189a6a1f105e383"
    end
  end

  bottle do
    sha256 "01b06c2983503c78bc346b5f5e2c2bdccbc41d6f5ca759542eef712bf123ca30" => :mojave
    sha256 "9824d06b8d0d44e725a1d29f6631828b3b43abb1952c883e9fad559b6a816c04" => :high_sierra
    sha256 "cf7371e9f6257d1a7dee80239d05917e424e5bb3e7577bd93f0e139fe5174198" => :sierra
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

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --enable-targets=all
      --with-python=/usr
      --disable-binutils
    ]

    system "./configure", *args
    system "make"

    # Don't install bfd or opcodes, as they are provided by binutils
    system "make", "install-gdb"
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
