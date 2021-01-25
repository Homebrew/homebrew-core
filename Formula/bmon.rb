class Bmon < Formula
  desc "Interface bandwidth monitor"
  homepage "https://github.com/tgraf/bmon"
  url "https://github.com/tgraf/bmon/releases/download/v4.0/bmon-4.0.tar.gz"
  sha256 "02fdc312b8ceeb5786b28bf905f54328f414040ff42f45c83007f24b76cc9f7a"
  license "BSD-2-Clause"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "c5a460a6ada9a74638176734db89e6e7fc6f8c171a8e580d06bb7b77b9432c1b" => :big_sur
    sha256 "8f20f07b392953df52502a35c4430ae3f080e4cf8b932a95fa66c149e04ff149" => :arm64_big_sur
    sha256 "0e5a38ac18b9a385c33eeedd7c64c649bad0a6160aada5725cf3c1b2557b74f8" => :catalina
    sha256 "54c90f958df855b99cc0b6fa4cbabd4b135e7913b844d774e607fb6d14045dcf" => :mojave
  end

  head do
    url "https://github.com/tgraf/bmon.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"

  uses_from_macos "ncurses"

  def install
    # Workaround for https://github.com/tgraf/bmon/issues/89 build issue:
    inreplace "include/bmon/bmon.h", "#define __unused__", "//#define __unused__"
    inreplace %w[src/in_proc.c src/out_curses.c], "__unused__", ""

    system "./autogen.sh" if build.head?
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"bmon", "-o", "ascii:quitafter=1"
  end
end
