class Global < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftpmirror.gnu.org/gnu/global/global-6.7.tar.gz"
  mirror "https://ftp.gnu.org/gnu/global/global-6.7.tar.gz"
  sha256 "fdab590c9bda2d68d55e99c51c7e60c2c8595ae4dcebab9bbbb0795f2a5c8bf7"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "61becbfb303939428359773d7ae7c96d5e6d869dc05e6d7437cbf73b0bde364a"
    sha256 arm64_sequoia: "104437cf6c9a196013efeac2bd195b94edacf4fd113980944200a67eb25e6772"
    sha256 arm64_sonoma:  "0ecdc3b9e6d7e912336f4ac722acad2e96904ff6da0f6cc206e67e2c9eff7c74"
    sha256 sonoma:        "bbc374bb1ec1ef3e45102eadd08614cfb674d0f0c30be1dd788098c306ca5235"
    sha256 arm64_linux:   "39b589b953e08dbd0714e21311c69564433d7493cbba01bcb6611982c1284ce0"
    sha256 x86_64_linux:  "55f9d6c8fa78c5fd9e0980b57c9bd2d56dd72d6611c7823092c2944464aea56d"
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
  depends_on "python@3.14"
  depends_on "sqlite"
  depends_on "universal-ctags"

  skip_clean "lib/gtags"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def python3
    "python3.14"
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
