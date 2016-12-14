class UniversalBrewedPython < Requirement
  satisfy { !OS.mac? || archs_for_command("python").universal? }

  def message; <<-EOS.undent
    A build of GDB using a brewed Python was requested, but Python is not
    a universal build.

    GDB requires Python to be built as a universal binary or it will fail
    if attempting to debug a 32-bit binary on a 64-bit host.
    EOS
  end
end

class Gdb < Formula
  desc "GNU debugger"
  homepage "https://www.gnu.org/software/gdb/"
  url "https://ftpmirror.gnu.org/gdb/gdb-7.12.tar.xz"
  mirror "https://ftp.gnu.org/gnu/gdb/gdb-7.12.tar.xz"
  sha256 "834ff3c5948b30718343ea57b11cbc3235d7995c6a4f3a5cecec8c8114164f94"
  revision 1

  bottle do
    sha256 "cddcc8e78bbff0cabe56a2d2a57ce9045defcb3ec28d17871d014171fc582465" => :sierra
    sha256 "6cec71a37016b259d5e07f4de0a828075bc556252635078cc70ee8870bd7c9d8" => :el_capitan
    sha256 "79c050699683460e4a78c3055a602665b2fc8dd72f639edab61cbe6f48ae79f7" => :yosemite
    sha256 "c677167843b66daa7a077348949525955a6f580b28693c577cb7b0ae4b16420f" => :x86_64_linux
  end

  deprecated_option "with-brewed-python" => "with-python"

  if OS.mac?
    option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  else
    option "without-python", "Use the system version of Python; by default Homebrew Python is used"
  end
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "guile" => :optional
  depends_on "texinfo" => :build unless OS.mac?
  depends_on "homebrew/dupes/ncurses" unless OS.mac?

  if MacOS.version >= :sierra
    patch do
      # Patch is needed to work on new 10.12 installs with SIP.
      # See http://sourceware-org.1504.n7.nabble.com/gdb-on-macOS-10-12-quot-Sierra-quot-td415708.html
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/9d3dbc2/gdb/0001-darwin-nat.c-handle-Darwin-16-aka-Sierra.patch"
      sha256 "a71489440781ae133eeba5a3123996e55f72bd914dbfdd3af0b0700f6d0e4e08"
    end
  end

  if build.with? "python"
    depends_on UniversalBrewedPython
  end

  def install
    args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
    ]

    args << "--with-guile" if build.with? "guile"
    args << "--enable-targets=all" if build.with? "all-targets"

    if build.with? "python"
      args << "--with-python=#{HOMEBREW_PREFIX}"
    elsif OS.mac?
      args << "--with-python=/usr"
    end

    if build.with? "version-suffix"
      args << "--program-suffix=-#{version.to_s.slice(/^\d/)}"
    end

    system "./configure", *args
    system "make"
    system "make", "install"

    # Remove conflicting items with binutils
    rm_rf include
    rm_rf lib
    rm_rf share/"locale"
    rm_rf share/"info"
  end

  def caveats; <<-EOS.undent
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
