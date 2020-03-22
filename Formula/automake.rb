class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.2.tar.xz"
  sha256 "ccc459de3d710e066ab9e12d2f119bd164a08c9341ca24ba22c9adaa179eedd0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f5e0528293a5f6d2ec5c686d5408f8b48489e8b1cfbcb3ebaab844a241d3565" => :catalina
    sha256 "0a359c2385d0673ce1ab3cdaf39dd22af191f7b74732105ca5751e08a334e061" => :mojave
    sha256 "fb32c065aaf91661380af32ed301edcf209ba453635c79ca945353b67e54af10" => :high_sierra
    sha256 "fb32c065aaf91661380af32ed301edcf209ba453635c79ca945353b67e54af10" => :sierra
    sha256 "d552844779f0dc4062f27203f7facfbd74c9d1780724ac76a86791e401aa73bd" => :el_capitan
  end

  depends_on "autoconf"

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
