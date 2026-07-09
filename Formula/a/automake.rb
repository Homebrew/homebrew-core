class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftpmirror.gnu.org/gnu/automake/automake-1.18.1.tar.xz"
  mirror "https://ftp.gnu.org/gnu/automake/automake-1.18.1.tar.xz"
  sha256 "168aa363278351b89af56684448f525a5bce5079d0b6842bd910fdd3f1646887"
  license "GPL-2.0-or-later"
  revision 1
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a1c4b30862df532469570dc672c7d1e9b0644d54641c2b384d9f9466f13cd792"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a1c4b30862df532469570dc672c7d1e9b0644d54641c2b384d9f9466f13cd792"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a1c4b30862df532469570dc672c7d1e9b0644d54641c2b384d9f9466f13cd792"
    sha256 cellar: :any_skip_relocation, tahoe:         "b903bd0af0e9b92893627e57a9f2ba912741665bd66585fd5439325f6e333927"
    sha256 cellar: :any_skip_relocation, sequoia:       "b903bd0af0e9b92893627e57a9f2ba912741665bd66585fd5439325f6e333927"
    sha256 cellar: :any_skip_relocation, sonoma:        "b903bd0af0e9b92893627e57a9f2ba912741665bd66585fd5439325f6e333927"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "82e16310fa008f762e8b82fba625f8eb57852b97da5cf372fceb8a500f7c6bfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82e16310fa008f762e8b82fba625f8eb57852b97da5cf372fceb8a500f7c6bfd"
  end

  depends_on "autoconf"

  def install
    ENV["PERL"] = "/usr/bin/perl" if OS.mac?

    # We specify `HOMEBREW_PREFIX` so that aclocal is compiled with the
    # correct system value for acdir (`HOMEBREW_PREFIX/share/aclocal`)
    # We also patch `configure` so that the normal installation prefix
    # is used when we call `make install`
    inreplace "configure", "${datadir}", "${datarootdir}"
    system "./configure", "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--datarootdir=#{share}",
                          "--datadir=#{HOMEBREW_PREFIX}/share",
                          *std_configure_args
    system "make", "install"

    # Use dirlist to add common search dirs for aclocal
    (share/"aclocal/dirlist").write <<~EOS
      /usr/share/aclocal
    EOS
  end

  test do
    # Check that the compiled system value for acdir does not use automake's versioned path
    assert_equal "#{HOMEBREW_PREFIX}/share/aclocal", shell_output("#{bin}/aclocal --print-ac-dir").chomp

    (testpath/"test.c").write <<~C
      int main() { return 0; }
    C
    (testpath/"configure.ac").write <<~M4
      AC_INIT(test, 1.0)
      AM_INIT_AUTOMAKE
      AC_PROG_CC
      AC_CONFIG_FILES(Makefile)
      AC_OUTPUT
    M4
    (testpath/"Makefile.am").write <<~MAKE
      bin_PROGRAMS = test
      test_SOURCES = test.c
    MAKE
    system bin/"aclocal"
    system bin/"automake", "--add-missing", "--foreign"
    system "autoconf"
    system "./configure"
    system "make"
    system "./test"
  end
end
