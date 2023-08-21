class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.5.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.5.tar.xz"
  sha256 "f01d58cd6d9d77fbdca9eb4bbd5ead1988228fdb73d6f7a201f5f8d6b118b469"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f68481d06be7fa3f0a0881edb825a336e7f6548191c762d68bd817183b238f5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f68481d06be7fa3f0a0881edb825a336e7f6548191c762d68bd817183b238f5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f68481d06be7fa3f0a0881edb825a336e7f6548191c762d68bd817183b238f5a"
    sha256 cellar: :any_skip_relocation, ventura:        "ae77a247a13ea860236a29b02769f5327395f712413f694d8a8d20cb6c21332d"
    sha256 cellar: :any_skip_relocation, monterey:       "ae77a247a13ea860236a29b02769f5327395f712413f694d8a8d20cb6c21332d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae77a247a13ea860236a29b02769f5327395f712413f694d8a8d20cb6c21332d"
    sha256 cellar: :any_skip_relocation, catalina:       "ae77a247a13ea860236a29b02769f5327395f712413f694d8a8d20cb6c21332d"
    sha256 cellar: :any_skip_relocation, mojave:         "ae77a247a13ea860236a29b02769f5327395f712413f694d8a8d20cb6c21332d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59808c20f7dc565f106b432941b43c52f3d7f46a8d562ab27a4aabd424783158"
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
