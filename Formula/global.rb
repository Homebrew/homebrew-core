class Global < Formula
  include Language::Python::Shebang

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.6.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.6.tar.gz"
  sha256 "758078afff98d4c051c58785c7ada3ed1977fabb77f8897ff657b71cc62d4d5d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "f96368bfa6146b1e1ab6df7fa7a830edac7a733e5e5b166da466279cd95f7f24"
    sha256 big_sur:       "b46b54119d50cad76ba3d214e3bfa746f3734fd36da87b59c8ad94368dd635c3"
    sha256 catalina:      "60e5977d1120c5e9f5044a424e74626e9ac713f9b5df994e6f3dc65ce9bc121e"
    sha256 mojave:        "2090e947b5325e6c6927d1c7ada590cedfbe765722eb2376b6690ebacf7bfdbf"
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

  depends_on "ctags"
  depends_on "python@3.9"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "libtool" => :build
  end

  skip_clean "lib/gtags"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/ba/6e/7a7c13c21d8a4a7f82ccbfe257a045890d4dbf18c023f985f565f97393e3/Pygments-2.9.0.tar.gz"
    sha256 "a18f47b506a429f6f4b9df81bb02beab9ca21d0a5fee38ed15aef65f0545519f"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages("python3")

    resource("Pygments").stage do
      system "python3", *Language::Python.setup_install_args(libexec)
    end

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
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

    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=pygments .")
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.py", shell_output("#{bin}/global -d pyfunc")
    assert_match "test.py", shell_output("#{bin}/global -d py2func")
    assert_match "test.py", shell_output("#{bin}/global -r py2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
    assert_match "test.py", shell_output("#{bin}/global -s pyvar")

    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=exuberant-ctags .")
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
    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
  end
end
