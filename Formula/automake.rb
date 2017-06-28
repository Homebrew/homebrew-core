class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.15.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.15.1.tar.xz"
  sha256 "af6ba39142220687c500f79b4aa2f181d9b24e4f8d8ec497cea4ba26c64bedaf"

  bottle do
    cellar :any_skip_relocation
    sha256 "d2b27ce7782a966eb7c8570f7855c8c659bbefc97491a1fb54b66e7b58d26c63" => :sierra
    sha256 "0b25b38f9df72b7869783514811b7ccd17284a240a7ee5950da501811b9942ff" => :el_capitan
    sha256 "0b25b38f9df72b7869783514811b7ccd17284a240a7ee5950da501811b9942ff" => :yosemite
  end

  keg_only :provided_until_xcode43

  depends_on "autoconf" => :run

  def install
    ENV["PERL"] = "/usr/bin/perl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<-EOS.undent
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<-EOS.undent
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<-EOS.undent
      bin_PROGRAMS = test
      test_SOURCES = test.c
    EOS
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
