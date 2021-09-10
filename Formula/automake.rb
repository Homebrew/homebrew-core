class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.4.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.4.tar.xz"
  sha256 "80facc09885a57e6d49d06972c0ae1089c5fa8f4d4c7cfe5baea58e5085f136d"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8e1bc79fe3243bb6853728d2471bddd0997aa8a6e04c79f023e6a358f8891dea"
    sha256 cellar: :any_skip_relocation, big_sur:       "c1f2f46b26a2ffa42f86165e0421d80728b6f97c6b42b61c9ff1e57199f36f64"
    sha256 cellar: :any_skip_relocation, catalina:      "c1f2f46b26a2ffa42f86165e0421d80728b6f97c6b42b61c9ff1e57199f36f64"
    sha256 cellar: :any_skip_relocation, mojave:        "c1f2f46b26a2ffa42f86165e0421d80728b6f97c6b42b61c9ff1e57199f36f64"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4df29c31b1e8b00c289aa857bf70dfd6eb189e7959864a8047aaaf4f4d8d699"
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
