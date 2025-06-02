class Global < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.14.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.14.tar.gz"
  sha256 "f6e7fd0b68aed292e85bb686616baf6551d5c9424adcddca11d808ba318cb320"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia: "11eed24d33dad01e9a23cd8d7ec8e0fa937af1828ee5d0cdd147b75a02e0a045"
    sha256 arm64_sonoma:  "48b7c70d65b140cfc53d4d82883640d2348b2a24f6e5456b97b532afb8395284"
    sha256 arm64_ventura: "38135ecf03e163025ce24ac2919964d0df0c554b7c1ddac5484f0a5be5f38e66"
    sha256 sonoma:        "25dd61063f62711b0b37222f890169382d50920254c7b269b3f2b1622f8c5609"
    sha256 ventura:       "32a73fdb042ecc97ee871d76794214ebc56ed8640298538ab1bd3135fdbeb4ba"
    sha256 arm64_linux:   "e74a6f93b81701a7afabf506dc688058f961b5ce5ef7b3fdfffc202daa0bec80"
    sha256 x86_64_linux:  "069518d2237ae351e7a27efb6f710d7d632c61261190454241022fd94ba4d620"
  end

  head do
    url ":pserver:anonymous:@cvs.savannah.gnu.org:/sources/global", using: :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    ## gperf is provided by OSX Command Line Tools.
    depends_on "libtool" => :build
  end

  depends_on "libtool"
  depends_on "ncurses"
  depends_on "python@3.13"
  depends_on "sqlite"
  depends_on "universal-ctags"

  skip_clean "lib/gtags"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/8e/62/8336eff65bcbc8e4cb5d05b55faf041285951b6e80f33e2bff2024788f31/pygments-2.18.0.tar.gz"
    sha256 "786ff802f32e91311bff3889f6e9a86e81505fe99f2735bb6d60ae0c5004f199"
  end

  def python3
    "python3.13"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    args = %W[
      --disable-dependency-tracking
      --sysconfdir=#{etc}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
      --with-python-interpreter=#{venv.root}/bin/python
      --with-universal-ctags=#{Formula["universal-ctags"].opt_bin}/ctags
    ]

    system "./configure", *args, *std_configure_args
    system "make", "install"

    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end

  test do
    (testpath/"test.c").write <<~C
      int c2func (void) { return 0; }
      void cfunc (void) {int cvar = c2func(); }")
    C
    (testpath/"test.py").write <<~PYTHON
      def py2func ():
           return 0
      def pyfunc ():
           pyvar = py2func()
    PYTHON

    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=pygments"
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc")
    assert_match "test.py", shell_output("#{bin}/global -d py2func")
    assert_match "test.py", shell_output("#{bin}/global -r py2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
    assert_match "test.py", shell_output("#{bin}/global -s pyvar")

    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=exuberant-ctags"
    # ctags only yields definitions
    assert_match "test.c", shell_output("#{bin}/global -d cfunc   # passes")
    assert_match "test.c", shell_output("#{bin}/global -d c2func  # passes")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc  # passes")
    assert_match "test.py", shell_output("#{bin}/global -d py2func # passes")
    refute_match "test.c", shell_output("#{bin}/global -r c2func  # correctly fails")
    refute_match "test.c", shell_output("#{bin}/global -s cvar    # correctly fails")
    refute_match "test.py", shell_output("#{bin}/global -r py2func # correctly fails")
    refute_match "test.py", shell_output("#{bin}/global -s pyvar   # correctly fails")

    # Test the default parser
    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=default"
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")

    # Test tag files in sqlite format
    system bin/"gtags", "--gtagsconf=#{share}/gtags/gtags.conf", "--gtagslabel=pygments", "--sqlite3"
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc")
    assert_match "test.py", shell_output("#{bin}/global -d py2func")
    assert_match "test.py", shell_output("#{bin}/global -r py2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
    assert_match "test.py", shell_output("#{bin}/global -s pyvar")
  end
end
