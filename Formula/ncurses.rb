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
    sha256 arm64_ventura:  "7f6ef060a13afca7fbd510a95b8f687e9a44f2c06ab18a68ee0037f60abebb67"
    sha256 arm64_monterey: "103cc4576dbcb2f907f07f612671d221c3a30ac4e0e30ac92232c1149734abd5"
    sha256 arm64_big_sur:  "89fba020401221224c789911e14ab04cef29610e247166e8536d7434993d978e"
    sha256 ventura:        "1460ee1a2732cde79771a8c22960897e9aa3e57da0410ddcc0560bc5fc113d9a"
    sha256 monterey:       "2ba0f33a4a8578f779f3dc5dbbc53aede3fa2c7f2c79b97ccfc71b34e4c4da53"
    sha256 big_sur:        "7e99f031d087a9662bf4c74d662a30b832a951349cab876b7652c0d0240509f0"
    sha256 x86_64_linux:   "abfe09d33077a2181c9802f34a8a71cd059b324663559b9853fd775d215c2ea6"
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

    prefix.install "test"
    (prefix/"test").install "install-sh", "config.sub", "config.guess"
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
    ENV["TERM"] = "xterm"

    system prefix/"test/configure", "--prefix=#{testpath}/test",
                                    "--with-curses-dir=#{prefix}"
    system "make", "install"

    system testpath/"test/bin/ncurses-examples"
  end
end
