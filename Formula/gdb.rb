class UniversalBrewedPython < Requirement
  satisfy { archs_for_command("python").universal? }

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

  bottle do
    sha256 "ce9602dbc92b1e1d986a1a5536fcef9baf3f703d08a86c4d18e4b411b20b2a4c" => :sierra
    sha256 "90b608379fefd418b72e6b73ae1bde9014d94b9f366259cbc3fea99dc63985b1" => :el_capitan
    sha256 "588dcb9acd832060e189004a4c7fef14b7a3bdeda3a7780b1f1bb8106c810327" => :yosemite
    sha256 "07db094029ff33ec19e0b90633f9a2b8fcceaec14d2bf30f7824b618ce993a3e" => :mavericks
  end

  deprecated_option "with-brewed-python" => "with-python"

  option "with-python", "Use the Homebrew version of Python; by default system Python is used"
  option "with-version-suffix", "Add a version suffix to program"
  option "with-all-targets", "Build with support for all targets"

  depends_on "pkg-config" => :build
  depends_on "python" => :optional
  depends_on "guile" => :optional

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
    else
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
    EOS
  end

  test do
    system bin/"gdb", bin/"gdb", "-configuration"
  end
end
