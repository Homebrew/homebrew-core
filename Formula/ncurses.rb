class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://www.gnu.org/software/ncurses/"
  url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.0.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.0.tar.gz"
  sha256 "f551c24b30ce8bfb6e96d9f59b42fbea30fa3a6123384172f9e7284bcf647260"
  revision 4

  bottle do
    sha256 "b0cc6b16a8f3b669442758113dde0771fe7533b00ed6c7476fbe0517ad16d3ca" => :high_sierra
    sha256 "178411a38ba6a4affcc8f5c6ce351b2f8ea213b97329013ff2fd6385e63a8a4f" => :sierra
    sha256 "08026e1a7dc4d53ec8bafcb1b0f40db3e9f029068d300fa8ba9275aa15457bdd" => :el_capitan
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  # stable rollup patch created by upstream see
  # https://invisible-mirror.net/archives/ncurses/6.0/README
  resource "ncurses-6.0-20170930-patch.sh" do
    url "https://invisible-mirror.net/archives/ncurses/6.0/ncurses-6.0-20170930-patch.sh.bz2"
    mirror "https://dl.bintray.com/homebrew/mirror/ncurses-6.0-20170930-patch.sh.bz2"
    sha256 "b179b2acf8838f4ed1c75c47db62109777d36a7e6efc1bd4e52e48cbd1bd4121"
  end

  def install
    # Fix the build for GCC 5.1
    # error: expected ')' before 'int' in definition of macro 'mouse_trafo'
    # See https://lists.gnu.org/archive/html/bug-ncurses/2014-07/msg00022.html
    # and https://trac.sagemath.org/ticket/18301
    # Disable linemarker output of cpp
    ENV.append "CPPFLAGS", "-P"

    (lib/"pkgconfig").mkpath

    # stage and apply patch
    buildpath.install resource("ncurses-6.0-20170930-patch.sh")
    system "sh", "ncurses-6.0-20170930-patch.sh"

    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--mandir=#{man}",
                          "--with-manpage-format=normal",
                          "--with-shared",
                          "--with-gpm=no"
    system "make"
    ENV.deparallelize
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.to_s.split(".")[0]

    %w[form menu ncurses panel].each do |name|
      lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.dylib"
      lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.#{major}.dylib"
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses++w.a" => "libncurses++.a"
    lib.install_symlink "libncurses.a" => "libcurses.a"
    lib.install_symlink "libncurses.dylib" => "libcurses.dylib"

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"

    bin.install_symlink "ncursesw#{major}-config" => "ncurses#{major}-config"

    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    ENV["TERM"] = "xterm"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/keynames"
    system testpath/"test/bin/test_arrays"
    system testpath/"test/bin/test_vidputs"
  end
end
