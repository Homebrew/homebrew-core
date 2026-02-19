class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://invisible-island.net/ncurses/announce.html"
  url "https://ftpmirror.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz"
  mirror "https://invisible-mirror.net/archives/ncurses/ncurses-6.6.tar.gz"
  mirror "ftp://ftp.invisible-island.net/ncurses/ncurses-6.6.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ncurses/ncurses-6.6.tar.gz"
  sha256 "355b4cbbed880b0381a04c46617b7656e362585d52e9cf84a67e2009b749ff11"
  license "X11-distribute-modifications-variant"

  bottle do
    sha256 arm64_tahoe:   "b43443ba3c3c8728e79413c7c3fed4a0eb293bd77c8492c1ec4c5d05233a97f1"
    sha256 arm64_sequoia: "3fe0a6d4482023f880e9542af63e9229c6fcd7456b46e88b5d2d4703eb2ec943"
    sha256 arm64_sonoma:  "d4df00300346955c4703c7deecd3affca58a0a27477087d6ff387beb30a3ac9f"
    sha256 sonoma:        "3981626d4214e14e1d01528b4652e0c9ac470c0a63fc2c995b875cd39efd1976"
    sha256 arm64_linux:   "02abc7eacf7d1f27c992888494a19a397bd4911fc6a92c34db232714488aec12"
    sha256 x86_64_linux:  "12c037b176c3300398cc53f0f278ba14195ae525cb6188dc085fd07236e5db48"
  end

  keg_only :provided_by_macos

  def install
    ENV.delete("TERMINFO")

    args = [
      "--prefix=#{prefix}",
      "--enable-pc-files",
      "--with-pkg-config-libdir=#{lib}/pkgconfig",
      "--enable-sigwinch",
      "--enable-symlinks",
      "--enable-widec",
      "--with-shared",
      "--with-cxx-shared",
      "--with-gpm=no",
      "--without-ada",
    ]
    args << "--with-terminfo-dirs=#{share}/terminfo:/etc/terminfo:/lib/terminfo:/usr/share/terminfo" if OS.linux?

    system "./configure", *args
    system "make", "install"
    make_libncurses_symlinks

    # Avoid hardcoding Cellar paths in client software.
    inreplace bin/"ncursesw6-config", prefix, opt_prefix
    pkgshare.install "test"
    (pkgshare/"test").install "install-sh", "config.sub", "config.guess"
  end

  def make_libncurses_symlinks
    major = version.major.to_s

    %w[form menu ncurses panel ncurses++].each do |name|
      lib.install_symlink shared_library("lib#{name}w", major) => shared_library("lib#{name}")
      lib.install_symlink shared_library("lib#{name}w", major) => shared_library("lib#{name}", major)
      lib.install_symlink "lib#{name}w.a" => "lib#{name}.a"
      lib.install_symlink "lib#{name}w_g.a" => "lib#{name}_g.a"
    end

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

    include.install_symlink "ncursesw" => "ncurses"
    include.install_symlink [
      "ncursesw/curses.h", "ncursesw/form.h", "ncursesw/ncurses.h",
      "ncursesw/panel.h", "ncursesw/term.h", "ncursesw/termcap.h"
    ]
  end

  test do
    refute_match prefix.to_s, shell_output("#{bin}/ncursesw6-config --prefix")
    refute_match share.to_s, shell_output("#{bin}/ncursesw6-config --terminfo-dirs")

    ENV["TERM"] = "xterm"

    system pkgshare/"test/configure", "--prefix=#{testpath}",
                                      "--with-curses-dir=#{prefix}"
    system "make", "install"
    system testpath/"bin/ncurses-examples"
  end
end
