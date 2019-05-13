class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.3.tar.xz"
  sha256 "802f7ee309dcc547d65a68d61ebd6526762d26c3051f52caebe2189ac1ffd72e"
  head "https://sourceware.org/git/binutils-gdb.git"

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
