class Global < Formula
  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.1.tar.gz"
  sha256 "943dc440382d82454786bfd92b86946961cb2196039eceffd7eb551ac83759e4"

  bottle do
    sha256 "11efec3aa71fd20082b663d1bb72f481560d6900d3aeeaf5adaf3f084ec2cb2a" => :high_sierra
    sha256 "bcc45b2aed0022f58c1c1932b6bc63de795cf479b1524ad8fb3184f0a284017b" => :sierra
    sha256 "0d15ea454dad5358f3dd721b0b1395c7499f362335e0c3a37c115f915ff0f349" => :el_capitan
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

  option "with-ctags", "Enable Exuberant Ctags as a plug-in parser"
  option "with-pygments", "Enable Pygments as a plug-in parser (should enable exuberant-ctags too)"
  option "with-sqlite3", "Use SQLite3 API instead of BSD/DB API for making tag files"

  deprecated_option "with-exuberant-ctags" => "with-ctags"

  depends_on "ctags" => :optional

  skip_clean "lib/gtags"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/71/2a/2e4e77803a8bd6408a2903340ac498cb0a2181811af7c9ec92cb70b0308a/Pygments-2.2.0.tar.gz"
    sha256 "dbae1046def0efb574852fab9e90209b23f556367b5a320c0bcb871c77c3e8cc"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
    ]

    args << "--with-sqlite3" if build.with? "sqlite3"

    if build.with? "ctags"
      args << "--with-exuberant-ctags=#{Formula["ctags"].opt_bin}/ctags"
    end

    if build.with? "pygments"
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      pygments_args = %W[build install --prefix=#{libexec}]
      resource("Pygments").stage { system "python", "setup.py", *pygments_args }
    end

    system "./configure", *args
    system "make", "install"

    if build.with? "pygments"
      bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
    end

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
    if build.with?("pygments") || build.with?("ctags")
      (testpath/"test.py").write <<-EOS
        def py2func ():
             return 0
        def pyfunc ():
             pyvar = py2func()
      EOS
    end
    if build.with? "pygments"
      assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=pygments .")
      if build.with? "ctags"
        assert_match "test.c", shell_output("#{bin}/global -d cfunc")
        assert_match "test.c", shell_output("#{bin}/global -d c2func")
        assert_match "test.c", shell_output("#{bin}/global -r c2func")
        assert_match "test.py", shell_output("#{bin}/global -d pyfunc")
        assert_match "test.py", shell_output("#{bin}/global -d py2func")
        assert_match "test.py", shell_output("#{bin}/global -r py2func")
      else
        # Everything is a symbol in this case
        assert_match "test.c", shell_output("#{bin}/global -s cfunc")
        assert_match "test.c", shell_output("#{bin}/global -s c2func")
        assert_match "test.py", shell_output("#{bin}/global -s pyfunc")
        assert_match "test.py", shell_output("#{bin}/global -s py2func")
      end
      assert_match "test.c", shell_output("#{bin}/global -s cvar")
      assert_match "test.py", shell_output("#{bin}/global -s pyvar")
    end
    if build.with? "ctags"
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
    end
    if build.with? "sqlite3"
      assert shell_output("#{bin}/gtags --sqlite3 --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
      assert_match "test.c", shell_output("#{bin}/global -d cfunc")
      assert_match "test.c", shell_output("#{bin}/global -d c2func")
      assert_match "test.c", shell_output("#{bin}/global -r c2func")
      assert_match "test.c", shell_output("#{bin}/global -s cvar")
    end
    # C should work with default parser for any build
    assert shell_output("#{bin}/gtags --gtagsconf=#{share}/gtags/gtags.conf --gtagslabel=default .")
    assert_match "test.c", shell_output("#{bin}/global -d cfunc")
    assert_match "test.c", shell_output("#{bin}/global -d c2func")
    assert_match "test.c", shell_output("#{bin}/global -r c2func")
    assert_match "test.c", shell_output("#{bin}/global -s cvar")
  end
end
