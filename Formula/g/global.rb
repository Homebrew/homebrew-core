class Global < Formula
  include Language::Python::Shebang

  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.10.tar.gz"
  sha256 "2dd1e6a945e93c01390fb941a4e694f4c71bbd7569d64149c04e927bbf4dcce8"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "ee29492d0200b60982a55ac301888f9a0151cf265872c2b547ab554e78dad575"
    sha256 arm64_ventura:  "ab5d00488d82ef4d6bb53ab2b149584fa3349c07996c3c71335c8afcb97f983c"
    sha256 arm64_monterey: "04de3a2049cb3947e09af8d378384a8f882cb33833a59427e8b4f7504504d4d9"
    sha256 arm64_big_sur:  "e9417586ab588d26a6384d2ba010b406a2c0b4feadc4221d7745f2704605debd"
    sha256 sonoma:         "35ce37b34c58275860ef39f217e7d6152e9f3b2a93353e567d531e74f781d3a5"
    sha256 ventura:        "f572a117a2318f132d27272cf2872a10cceea9c436c8933a38c99884fb80b173"
    sha256 monterey:       "a55bfa20d77cda1e1d7448972511adf54e78311e8c03951ddeb2c0188b3fd085"
    sha256 big_sur:        "3a45c02b24c75ed96347d28b8fa67e767cf99ac02c8478d4f38c7abe50a46791"
    sha256 x86_64_linux:   "238f9b7b4ee814fe82a6b27d7adf171ec918d125563e2a212d108df9f2b9fa85"
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
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "sqlite"
  depends_on "universal-ctags"

  skip_clean "lib/gtags"

  def install
    system "sh", "reconf.sh" if build.head?

    python3 = "python3.11"
    ENV.prepend_create_path "PYTHONPATH", libexec/Language::Python.site_packages(python3)

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-sqlite3=#{Formula["sqlite"].opt_prefix}
      --with-universal-ctags=#{Formula["universal-ctags"].opt_bin}/ctags
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
