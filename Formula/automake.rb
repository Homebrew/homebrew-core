class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.3.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.3.tar.xz"
  sha256 "ff2bf7656c4d1c6fdda3b8bebb21f09153a736bcba169aaf65eab25fa113bf3a"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "91656222dff012c7434026ff250fcd92fd5746e60a383ef27547559b6bbfe4f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "11f09c63a49b30078f91bd00b8bed2408422100764cb7b039e8f96941aec3dfc"
    sha256 cellar: :any_skip_relocation, catalina:      "5f83d4723ee9f33c4a90d62c4bce9d200c4c74cc32d207e4f4d2bdaaede9fb7f"
    sha256 cellar: :any_skip_relocation, mojave:        "52796a1b6c737797964b119a5cf170a24fc55e32a43841e4690cce1cc24fed1a"
  end

  depends_on "autoconf"

  def install
    on_macos do
      ENV["PERL"] = "/usr/bin/perl"
    end

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
