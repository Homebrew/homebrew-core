class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftp.gnu.org/gnu/gdb/gdb-8.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/gdb/gdb-8.2.tar.xz"
  sha256 "c3a441a29c7c89720b734e5a9c6289c0a06be7e0c76ef538f7bbcef389347c39"
  revision 1

  bottle do
    sha256 "66aba1de069c94a7dbd24da8f29bba8a2415ba04ca55fc7e57fa33fa482885c4" => :mojave
    sha256 "6d35586ed4c646df660b4518838f7809c593a851ad171b86d5d44b6d30c780b4" => :high_sierra
    sha256 "bbf55e88a59cc9ccedd9771a8cab1c57a5395bbbb91ece45daa1214a2b36f5b9" => :sierra
    sha256 "cd3d64855ad850a25bdf7cb031ae837138579afbd2faebb5ec806dd3d22ca960" => :el_capitan
  end

  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-python@2", "Use the Homebrew version of Python 2; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  deprecated_option "with-brewed-python" => "with-python@2"
  deprecated_option "with-guile" => "with-guile@2.0"

  depends_on "pkg-config" => :build
  depends_on "guile@2.0" => :optional
  depends_on "python" => :optional
  depends_on "python@2" => :optional

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
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    args << "--with-guile" if build.with? "guile@2.0"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with?("python@2") && build.with?("python")
      odie "Options --with-python and --with-python@2 are mutually exclusive."
    elsif build.with?("python@2")
      args << "--with-python=#{Formula["python@2"].opt_bin}/python2"
      ENV.append "CPPFLAGS", "-I#{Formula["python@2"].opt_libexec}"
    elsif build.with?("python")
      args << "--with-python=#{Formula["python"].opt_bin}/python3"
      ENV.append "CPPFLAGS", "-I#{Formula["python"].opt_libexec}"
    else
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

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
