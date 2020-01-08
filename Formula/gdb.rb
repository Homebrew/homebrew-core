class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.3.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.3.1.tar.xz"
  sha256 "1e55b4d7cdca7b34be12f4ceae651623aa73b2fd640152313f9f66a7149757c4"
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 "ad116e52174fcb031a0694554ecb46a108b22c5aa7b7f71aa374a0d011805d0c" => :catalina
    sha256 "832e02507122f99636166486b7fa5b0004f98c3fb967e3c3e6a427b5ecbf81ed" => :mojave
    sha256 "c6f506f57a95d8ea21635874bfbc8493e3efd9b34f88ea5f8195d1f7cfa62805" => :high_sierra
  end

  depends_on "pkg-config" => :build

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
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
