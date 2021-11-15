class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://angband.github.io/angband/"
  url "https://github.com/angband/angband/releases/download/4.2.3/Angband-4.2.3.tar.gz"
  sha256 "833c4f8cff2aee61ad015f9346fceaa4a8c739fe2dbe5bd1acd580c91818e6bb"
  license "GPL-2.0-only"
  head "https://github.com/angband/angband.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_monterey: "0012d8a153dcf3036a9eab9314fb048031e0113209318aa919a6114edfaafdc8"
    sha256 arm64_big_sur:  "ab6002b750047f4c544b8427a2f021395b75ab7f9f93c26fc0f3625b758f5842"
    sha256 monterey:       "119541b0dec51b0e8f6dbb01b5d00b2f202921477154411adb4265cb5fbc2c10"
    sha256 big_sur:        "3f6aee791649219ab05f70d1c9170e09137d23ee31fcfdd3862c242dd2165771"
    sha256 catalina:       "c983b2033647d198120ae6295302f812fc7f35fc5d43e4bb430ff63f1fd89c31"
    sha256 mojave:         "6eb8682054143520fbf931cac520aa8b1c3e8776db5d8e13c374698563fba23e"
    sha256 x86_64_linux:   "c846da0bf2b065f0867cf114896938c321c5a86de031dfd0ec7bd94913425ac0"
  end

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
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
