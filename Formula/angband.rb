class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://rephial.org/downloads/4.2/angband-4.2.1.tar.gz"
  sha256 "acd735c9d46bf86ee14337c71c56f743ad13ec2a95d62e7115604621e7560d0f"
  license "GPL-2.0"
  head "https://github.com/angband/angband.git"

  livecheck do
    url :homepage
    regex(/href=.*?angband[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "156672377070d2d66c338e5ebc9e6a3ea0afd544a1da97f9ef35cdd2b0a859cc"
    sha256 big_sur:       "ed5e9c7b858074dbb7bea12199e8a326cd61e0335fb268e0d88894609995c88d"
    sha256 catalina:      "b59aedacab5c3588719bfc1ebc17b936ffe5105ed8e7edd19caccc340a81271f"
    sha256 mojave:        "96f6f2e31023c69aba44c4ccc40acf652d5a76bbd1b9cd6a7ebead33a0a2161e"
    sha256 high_sierra:   "95463908fbefe4988a9ab3dcc031cd1c7d6767ed6557d1baca813446e5ca6b9c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--bindir=#{bin}",
                          "--libdir=#{libexec}",
                          "--enable-curses",
                          "--disable-ncursestest",
                          "--disable-sdltest",
                          "--disable-x11",
                          "--with-ncurses-prefix=#{MacOS.sdk_path}/usr"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"angband", "--help"
  end
end
