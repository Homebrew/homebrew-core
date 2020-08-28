class Automake < Formula
  desc "Tool for generating GNU Standards-compliant Makefiles"
  homepage "https://www.gnu.org/software/automake/"
  url "https://ftp.gnu.org/gnu/automake/automake-1.16.2.tar.xz"
  mirror "https://ftpmirror.gnu.org/automake/automake-1.16.2.tar.xz"
  sha256 "ccc459de3d710e066ab9e12d2f119bd164a08c9341ca24ba22c9adaa179eedd0"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "06c47bab91fc9c8a912a162f02fbf4c6d03b75820110250d2408e694bacd8236" => :catalina
    sha256 "4b120878f02328e006cb51c2456f5ff26e8c5ad5688ac00fada4a53e72479ce6" => :mojave
    sha256 "4a98437a54592391f677ecea0bbac02f823e7f3168b9a782067cca9aa8f78b4e" => :high_sierra
  end

  depends_on "autoconf"

  # Download more up-to-date config scripts.
  resource "config" do
    url "https://git.savannah.gnu.org/cgit/config.git/snapshot/config-0b5188819ba6091770064adf26360b204113317e.tar.gz"
    sha256 "3dfb73df7d073129350b6896d62cabb6a70f479d3951f00144b408ba087bdbe8"
    version "2020-08-17"
  end

  def install
    ENV["PERL"] = "/usr/bin/perl"

    resource("config").stage do
      cp Dir["config.*"], buildpath/"lib"
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
