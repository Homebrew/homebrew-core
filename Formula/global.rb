class Global < Formula
  include Language::Python::Shebang

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.7.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.7.tar.gz"
  sha256 "69a0f77f53827c5568176c1d382166df361e74263a047f0b3058aa2f2ad58a3c"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 arm64_monterey: "020f4adf24f8ec865985ee316c21a28d723d04cbc5e40db25b7466821c4b1380"
    sha256 arm64_big_sur:  "ac6e9593809808317fae95123ae900984864af0c1b7b75e1654943d4859755a3"
    sha256 monterey:       "139ff10b422d0f54521e17d453d839468498986c890176951e9fb17f85d1d175"
    sha256 big_sur:        "9db539acdbe29519f9a658b014a9b7a76f0d0df4ed9dd8140360366059c3bc79"
    sha256 catalina:       "004ddf5a7ed57fb0793fb2b3680342643f30ca3429175c3d471a6746865a641d"
    sha256 mojave:         "25ac8252698696fb8c6dcac75d86d6e46f2c1a7c40442463a9183defedf098f8"
    sha256 x86_64_linux:   "e55a8b40f528a2b1047b5294f7403d3e56ab5f7efe76551f09db44b367b4acfd"
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

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "ctags"
  depends_on "libtool"
  depends_on "ncurses"
  depends_on "python@3.10"
  depends_on "sqlite"

  skip_clean "lib/gtags"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  # use homebrew sqlite instead of the older copy included in libdb/
  # When removing the patch, check whether we can remove the
  # autoconf/automake/libtool dependencies
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/bc4dc49c2476c2d4ffecb21bb76699e67cb57415/global/6.6.7-external-sqlite.patch"
    sha256 "1b87c9b90a6555cd77c72de933303348e1e148b71a5976d4a0040a3038ef2627"
  end

  def install
    if build.head?
      system "sh", "reconf.sh"
    else
      # Needed for the patch. Check that this can be removed when the patch is not necessary
      system "autoreconf", "--force", "--install", "--symlink", "--verbose"
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3")

    resource("Pygments").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
      --with-exuberant-ctags=#{Formula["ctags"].opt_bin}/ctags
    ]

    system "./configure", *args
    system "make", "install"

    rewrite_shebang detected_python_shebang, share/"gtags/script/pygments_parser.py"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])

    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      int c2func (void) { return 0; }
      void cfunc (void) {int cvar = c2func(); }")
    EOS
    (testpath/"test.py").write <<~EOS
      def py2func ():
           return 0
      def pyfunc ():
           pyvar = py2func()
    EOS

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
