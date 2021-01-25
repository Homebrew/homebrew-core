class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://www.gnu.org/software/ncurses/"
  url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.2.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.2.tar.gz"
  sha256 "30306e0c76e0f9f1f0de987cf1c82a5c21e1ce6568b9227f7da5b71cbea86c9d"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 "b34b4aa433f23405c6104bf810836eed2686f11c660b8668a7af86f99be2329f" => :big_sur
    sha256 "111ab64b5ffbe5aebe18096a2ff95e8e8f6426955799181db8338677e8f853e4" => :arm64_big_sur
    sha256 "eae51ad3391edafe3d6c649ba44f607ee1464b4b5d9ee48770e9817ee5f0ccdd" => :catalina
    sha256 "1771e0ce821cf8cbe38d0ce8d1843fd559532923222edc5dbf5b31fcf24fed90" => :mojave
    sha256 "4648be8457b081026d3da80f290abaf3fbfdcb49d62914861a63fc706f9adabe" => :high_sierra
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gpatch" => :build
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pc-files",
                          "--with-pkg-config-libdir=#{lib}/pkgconfig",
                          "--enable-sigwinch",
                          "--enable-symlinks",
                          "--enable-widec",
                          "--with-shared",
                          "--with-gpm=no"
    system "make", "install"
    make_libncurses_symlinks

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.major

    %w[form menu ncurses panel].each do |name|
      on_macos do
        lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.dylib"
        lib.install_symlink "lib#{name}w.#{major}.dylib" => "lib#{name}.#{major}.dylib"
      end
      on_linux do
        lib.install_symlink "lib#{name}w.so.#{major}" => "lib#{name}.so"
        lib.install_symlink "lib#{name}w.so.#{major}" => "lib#{name}.so.#{major}"
      end
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

    lib.install_symlink "libncurses++w.a" => "libncurses++.a"
    lib.install_symlink "libncurses.a" => "libcurses.a"
    lib.install_symlink shared_library("libncurses") => shared_library("libcurses")
    on_linux do
      # libtermcap and libtinfo are provided by ncurses and have the
      # same api. Help some older packages to find these dependencies.
      # https://bugs.centos.org/view.php?id=11423
      # https://bugs.launchpad.net/ubuntu/+source/ncurses/+bug/259139
      lib.install_symlink "libncurses.so" => "libtermcap.so"
      lib.install_symlink "libncurses.so" => "libtinfo.so"
    end

    (lib/"pkgconfig").install_symlink "ncursesw.pc" => "ncurses.pc"
    (lib/"pkgconfig").install_symlink "formw.pc" => "form.pc"
    (lib/"pkgconfig").install_symlink "menuw.pc" => "menu.pc"
    (lib/"pkgconfig").install_symlink "panelw.pc" => "panel.pc"

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
