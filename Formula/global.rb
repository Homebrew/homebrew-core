class Global < Formula
  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.3.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.3.tar.gz"
  sha256 "cbee98ef6c1b064bc5b062d14a6d94dca67289e8374860817057db7688bc651c"

  bottle do
    sha256 "a7c38baeddffcd462c81d75f880a883e197256b942157e26850223b9cad2494b" => :mojave
    sha256 "437111cf310d59b8834b4ed82455a88177ea53c23bf34eb92ffd31c40d77f62f" => :high_sierra
    sha256 "1239020a37f617c1f128a54d2be7b25bbc328772113e77d9d0522f4d4e07a86a" => :sierra
  end

  head do
    url ":pserver:anonymous:@cvs.savannah.gnu.org:/sources/global", :using => :cvs

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "flex" => :build
    ## gperf is provided by OSX Command Line Tools.
    depends_on "libtool" => :build
  end

  depends_on "ctags"
  depends_on "python"

  skip_clean "lib/gtags"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    pygments_args = %W[build install --prefix=#{libexec}]
    resource("Pygments").stage { system "python3", "setup.py", *pygments_args }

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-exuberant-ctags=#{Formula["ctags"].opt_bin}/ctags
    ]

    system "./configure", *args
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])

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
    assert_no_match(/test\.c/, shell_output("#{bin}/global -r c2func  # correctly fails"))
    assert_no_match(/test\.c/, shell_output("#{bin}/global -s cvar    # correctly fails"))
    assert_no_match(/test\.py/, shell_output("#{bin}/global -r py2func # correctly fails"))
    assert_no_match(/test\.py/, shell_output("#{bin}/global -s pyvar   # correctly fails"))

    # Test the default parser
    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
  end
end
