class Global < Formula
  desc "Source code tag system"
  homepage "https://www.gnu.org/software/global/"
  url "https://ftp.gnu.org/gnu/global/global-6.6.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/global/global-6.6.5.tar.gz"
  sha256 "9c3730bd9e975d94231f3402d5526b79c0b23cc665d624c9829c948dfad37b83"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "748524c4b316196e41e0f54df683117c61f7dfdbab1c3e641c36ae4eed7f1013" => :catalina
    sha256 "848b4e78c1f507bc4356b285164368641125194e730accf46c540af5806a600f" => :mojave
    sha256 "ba9cdd8c988ca4aff95538b8d30cb9f97c99dd6f5e91e296db121c8b53459cf0" => :high_sierra
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
    url "https://files.pythonhosted.org/packages/5d/0e/ff13c055b014d634ed17e9e9345a312c28ec6a06448ba6d6ccfa77c3b5e8/Pygments-2.7.2.tar.gz"
    sha256 "381985fcc551eb9d37c52088a32914e00517e57f4a21609f48141ba08e193fa0"
  end

  def install
    system "sh", "reconf.sh" if build.head?

    xy = Language::Python.major_minor_version "python3"
    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python#{xy}/site-packages"
    pygments_args = %W[build install --prefix=#{libexec}]
    resource("Pygments").stage { system "#{Formula["python@3.9"].opt_bin}/python3", "setup.py", *pygments_args }

    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-exuberant-ctags=#{Formula["ctags"].opt_bin}/ctags
    ]

    # Fix detection of realpath() with Xcode >= 12
    ENV.append_to_cflags "-Wno-error=implicit-function-declaration"

    system "./configure", *args
    system "make"
    system "make", "install"

    bin.env_script_all_files(libexec/"bin", PYTHONPATH: ENV["PYTHONPATH"])

    etc.install "gtags.conf"

    # we copy these in already
    cd share/"gtags" do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
    inreplace share/"gtags/script/pygments_parser.py", "#!/usr/bin/env python",
      "#!#{Formula["python@3.9"].opt_bin}/python3"
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
