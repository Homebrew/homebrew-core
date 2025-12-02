class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://invisible-island.net/ncurses/announce.html"
  url "https://ftpmirror.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz"
  mirror "https://invisible-mirror.net/archives/ncurses/ncurses-6.5.tar.gz"
  mirror "ftp://ftp.invisible-island.net/ncurses/ncurses-6.5.tar.gz"
  mirror "https://ftp.gnu.org/gnu/ncurses/ncurses-6.5.tar.gz"
  sha256 "136d91bc269a9a5785e5f9e980bc76ab57428f604ce3e5a5a90cebc767971cc6"
  license "X11-distribute-modifications-variant"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "cdf1f60b77e8f2f431f010c987a57452b95c1c6426e4ddf829f701f6e7ce5058"
    sha256 arm64_sequoia:  "4a529cb864994c26766c55ae8e506297523b36319e0f5f5af0faf8250a451f77"
    sha256 arm64_sonoma:   "ee5253473badfa0701deac8e9973a7358c761dd287f0d748f753130a7a6d2705"
    sha256 arm64_ventura:  "b79562983390463a00077616c6b3e460aa170bdca43f32839af802aac594aae0"
    sha256 arm64_monterey: "75db7bcba54b3acdb36b0dd08f0ce0a0631f7bfda83da3877aab35242ff7276a"
    sha256 sonoma:         "eb22b3753261f99aa36f5d9e1511a0bca5ea70cd645f7068af2ac5514aafd6a7"
    sha256 ventura:        "d6316fb9989753d52db231cc4dfe20746c5e2b6dced2ba6136ad1f11e99814aa"
    sha256 monterey:       "9c262007804eca602c67d686878778051d2ff813237d6805665831a1ea705477"
    sha256 arm64_linux:    "a41105c555fcaf7cc16cf53be73187724576129a8c39902378d742a8dc396850"
    sha256 x86_64_linux:   "7c49662d0f319baec24475d38210b2f9c754b2ec1d21a4a3ff39ce81d8605f03"
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

    odie "`-std=gnu17` workaround should be removed!" if build.stable? && version > "6.5"
    ENV.append_to_cflags "-std=gnu17" if OS.linux? && DevelopmentTools.gcc_version("gcc") >= 15

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
