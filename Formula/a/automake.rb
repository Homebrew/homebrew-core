class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.17.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.17.tar.xz"
  sha256 "8920c1fc411e13b90bf704ef9db6f29d540e76d232cb3b2c9f4dc4cc599bd990"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7e4b29a71b7f3b192f6dcc3bcf5b794a4548786c66df2f2ef71cf097099c6825"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aaf3cb57d50c48af4886c0cd24340aa6ca5628feac4a566254a878f378aaa2e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aaf3cb57d50c48af4886c0cd24340aa6ca5628feac4a566254a878f378aaa2e5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aaf3cb57d50c48af4886c0cd24340aa6ca5628feac4a566254a878f378aaa2e5"
    sha256 cellar: :any_skip_relocation, sequoia:        "3b8ba6298652b182425648330075f40f7fa6e55296a7463accc47884ecd26c67"
    sha256 cellar: :any_skip_relocation, sonoma:         "5548bc61f131a45a0aad86b38f044530a51b10243a95188101438e42842f10d9"
    sha256 cellar: :any_skip_relocation, ventura:        "5548bc61f131a45a0aad86b38f044530a51b10243a95188101438e42842f10d9"
    sha256 cellar: :any_skip_relocation, monterey:       "5548bc61f131a45a0aad86b38f044530a51b10243a95188101438e42842f10d9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca591433edbdc896db26cea86f61dfbacea15e794828e7280482de2126d89e3e"
  end

  depends_on "autoconf"

  def install
    ENV["PERL"] = "/usr/bin/perl" if OS.mac?

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
