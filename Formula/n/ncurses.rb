class Ncurses < Formula
  desc "Text-based UI library"
  homepage "https://invisible-island.net/ncurses/announce.html"
  url "https://ftp.gnu.org/gnu/ncurses/ncurses-6.4.tar.gz"
  mirror "https://invisible-mirror.net/archives/ncurses/ncurses-6.4.tar.gz"
  mirror "ftp://ftp.invisible-island.net/ncurses/ncurses-6.4.tar.gz"
  mirror "https://ftpmirror.gnu.org/ncurses/ncurses-6.4.tar.gz"
  sha256 "6931283d9ac87c5073f30b6290c4c75f21632bb4fc3603ac8100812bed248159"
  license "MIT"

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "77f64a7cb19a73264573f58c05cc76869a788d192b84934642bae8732f0df1b7"
    sha256 arm64_ventura:  "8afdd105a6b1d9ec6c567edfe5a08dd3eff5bece58fc29894ff64ae3851c4ddb"
    sha256 arm64_monterey: "b841fae8df4143be3b7e5d0cf711f0514b0ef45592c0737c1bf416ee972283d4"
    sha256 arm64_big_sur:  "18dd7acd5aad938bf0d7d27bd930fe6d846161aa0dad148b086eceb392eeb67d"
    sha256 sonoma:         "3111efe7420b7dd00eb9ff5736fb0ba981bd6d6f49042c4dff067a96b146cae7"
    sha256 ventura:        "f31d17ab8166110d3dd0337b240c616acf33a3582c0ded2fbe4db61fbdda1b5d"
    sha256 monterey:       "cd6258524addc5ac1fdbbd92e7e2c46b240cae5d0c4fa771c0976da861f7198f"
    sha256 big_sur:        "b5e8d53b2860f5c778ac99d01417a0596c66ebab670169e8a472d65c253870ba"
    sha256 x86_64_linux:   "58970126fed5ca09650b60c453e2b911a85f038b45af9091b5b2ef2b61d7d40e"
  end

  keg_only :provided_by_macos

  depends_on "pkg-config" => :build

  on_linux do
    depends_on "gpatch" => :build
  end

  def install
    # Workaround for
    # macOS: mkdir: /usr/lib/pkgconfig:/opt/homebrew/Library/Homebrew/os/mac/pkgconfig/12: Operation not permitted
    # Linux: configure: error: expected a pathname, not ""
    (lib/"pkgconfig").mkpath

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
