class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-9.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-9.2.tar.xz"
  sha256 "360cd7ae79b776988e89d8f9a01c985d0b1fa21c767a4295e5f88cb49175c555"
  license "GPL-2.0"
  revision 1
  head "https://sourceware.org/git/binutils-gdb.git"

  bottle do
    sha256 "fbfb5bb6a5f8d7edb33937ebd505fbfe5074db3d49a0403803edafcbcbde297f" => :catalina
    sha256 "64fdeef2403ae8dad106d4933dc6b5c555d560249a18dccc0a518c53f8ea26b1" => :mojave
    sha256 "cbf828704099f07e8c863c962ef8deb60b932e3d75146a16b20967e3ddca7cbe" => :high_sierra
  end

  depends_on "python@3.8"
  depends_on "xz" # required for lzma support

  uses_from_macos "expat"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "guile"
  end

  conflicts_with "i386-elf-gdb", because: "both install include/gdb, share/gdb and share/info"

  fails_with :clang do
    build 800
    cause <<~EOS
      probe.c:63:28: error: default initialization of an object of const type
      'const any_static_probe_ops' without a user-provided default constructor
    EOS
  end

  def install
    args = %W[
      --enable-targets=all
      --prefix=#{prefix}
      --disable-debug
      --disable-dependency-tracking
      --with-lzma
      --with-python=#{Formula["python@3.8"].opt_bin}/python3
      --disable-binutils
    ]

    mkdir "build" do
      system "../configure", *args
      system "make"

      # Don't install bfd or opcodes, as they are provided by binutils
      system "make", "install-gdb"
    end
  end

  def caveats
    <<~EOS
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
