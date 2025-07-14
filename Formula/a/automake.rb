class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.18.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.18.1.tar.xz"
  sha256 "168aa363278351b89af56684448f525a5bce5079d0b6842bd910fdd3f1646887"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c00a332610983c37659eee42e4a93341a3051892481362d223a40f5435b7555"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c00a332610983c37659eee42e4a93341a3051892481362d223a40f5435b7555"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3c00a332610983c37659eee42e4a93341a3051892481362d223a40f5435b7555"
    sha256 cellar: :any_skip_relocation, sequoia:       "bddfb6ebd600671dbeb0c3e665a98bc971c97834f9b5fdfc15c17f6e3cd44de8"
    sha256 cellar: :any_skip_relocation, sonoma:        "bddfb6ebd600671dbeb0c3e665a98bc971c97834f9b5fdfc15c17f6e3cd44de8"
    sha256 cellar: :any_skip_relocation, ventura:       "bddfb6ebd600671dbeb0c3e665a98bc971c97834f9b5fdfc15c17f6e3cd44de8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5bc18b0f438a2b7776c8a2cec9f9c5a4189a46dd35b79046249ad9d3abd4da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5bc18b0f438a2b7776c8a2cec9f9c5a4189a46dd35b79046249ad9d3abd4da1"
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
    (testpath/"test.c").write <<~C
      int main() { return 0; }
    C
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
