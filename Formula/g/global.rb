class Global < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftpmirror.gnu.org/global/global-6.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.7.tar.gz"
  sha256 "fdab590c9bda2d68d55e99c51c7e60c2c8595ae4dcebab9bbbb0795f2a5c8bf7"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "659d46ce7d1b8e3bd9c91a497af921cc6d0b9107f1038abbb399a254be4499cb"
    sha256 arm64_tahoe:       "a323d15234aa887ab706d85c97a18166ee7e6a9fba7052709234528e927a631f"
    sha256 arm64_sequoia:     "de5bb9af0b57a012e6d305a648d0e772b1f4daec89a5ba823497fab11bf420cd"
    sha256 arm64_linux:       "4d24c39aab61adf5ff043c2d9532d132bdfd0eaa145e7fada1907674a66a557c"
    sha256 x86_64_linux:      "dad9cc3baab9bec8e98f7497eb258a3dc9b7a3ae70833f4881222c0e5a80cd25"
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
  depends_on "python@3.15"
  depends_on "sqlite"
  depends_on "universal-ctags"

  skip_clean "lib/gtags"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/49/2e/ced460408999b33da6b31b0021b0f37d329e202d4169aeb164493778f25b/pygments-2.21.0.tar.gz"
    sha256 "610ca751c9bc2492b38eb9a38a7fbc93edbbb2d7182edaf34e66ae493dee5c8c"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    venv = virtualenv_create(libexec, python3)
    venv.pip_install resources

    args = %W[
      --disable-dependency-tracking
      --sysconfdir=#{etc}
      --with-sqlite3=#{formula_opt_prefix("sqlite")}
      --with-python-interpreter=#{venv.root}/bin/python
      --with-universal-ctags=#{formula_opt_bin("universal-ctags")}/ctags
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
