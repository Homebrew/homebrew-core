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
    sha256 ventura:      "653c9164e734b074e7688d59250d33ea6a1b52ace2f4da61a1d8e3f666c031a7"
    sha256 monterey:     "4b3dab2ae56bc0df8de29113b853386a0db29f14035f01af6003bab9195418a1"
    sha256 big_sur:      "77a26612312e83da76b6fc7eaf14baf71ed62b6565cb87b63c8807897773fc83"
    sha256 catalina:     "91f4480cfccf02902efc12e30099f899704fb44eac21b96cd5d2e773328cc03b"
    sha256 x86_64_linux: "79529333571b0bceb8f8307582cc608e597fbed6be24392a0318e25590ebbd51"
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
