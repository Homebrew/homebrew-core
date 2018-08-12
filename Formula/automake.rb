class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.1.tar.xz"
  sha256 "5d05bb38a23fd3312b10aea93840feec685bdf4a41146e78882848165d3ae921"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "f9d2f7f913917ce686bf8dab00fe5c5f2c971038ed91b2a6ec8cd6be9efd9b31" => :high_sierra
    sha256 "f9d2f7f913917ce686bf8dab00fe5c5f2c971038ed91b2a6ec8cd6be9efd9b31" => :sierra
    sha256 "397f56ce7582b559171de62dfa772fc1a90d99bb1f03ae2f20e6824a243f7ae7" => :el_capitan
  end

  depends_on "autoconf"

  # http://gnu-automake.7480.n7.nabble.com/bug-31222-automake-1-16-1-am-pep3147-tweak-bug-td22937.html
  # Remove this when applying any future 1.16.2 update.
  patch do
    url "https://git.savannah.gnu.org/cgit/automake.git/patch/?id=a348d830659fffd2cfc42994524783b07e69b4b5"
    sha256 "7a57ca2b91f7f3c0b168cf5ffbc8a1b2168f3886bcadcc15412281472dace3ce"
  end

  def install
    ENV["PERL"] = "/usr/bin/perl"

    system "./configure", "--prefix=#{prefix}"
    system "make", "install"

    # Our aclocal must go first. See:
    # https://github.com/Homebrew/homebrew/issues/10618
    (share/"aclocal/dirlist").write <<~EOS
      #{HOMEBREW_PREFIX}/share/aclocal
      /usr/share/aclocal
    EOS
  end

  test do
    (testpath/"test.c").write <<~EOS
      int main() { return 0; }
    EOS
    (testpath/"configure.ac").write <<~EOS
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    EOS
    (testpath/"Makefile.am").write <<~EOS
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
