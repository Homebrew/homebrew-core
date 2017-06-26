class Angband < Formula
  desc "Dungeon exploration game"
  homepage "http://rephial.org/"
  url "http://rephial.org/downloads/4.1/angband-4.1.0.tar.gz"
  sha256 "ea52266e52b66d6bf2ab3728b3bc6c7c3875130973430021e31bf56000c0df8b"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "f3e87c6c6e443fb4807d1473939c47b664ae77c6d0ccf351ac9f08fdc5fe1c8a" => :sierra
    sha256 "0f4d8be0d57e68a136d38bc34a4afd6d0df1ecebbe9539be2a25e0e5b3057c9f" => :el_capitan
    sha256 "667101e3cdd23661642f61493bc879cce67257c0e78de3100ebd74506ca7ede9" => :yosemite
  end

  option "with-cocoa", "Install Cocoa app"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "sdl" => :optional
  if build.with? "sdl"
    depends_on "sdl_image"
    depends_on "sdl_ttf"
    depends_on "sdl_mixer" => "with-smpeg"
  end

  def install
    ENV["NCURSES_CONFIG"] = "#{MacOS.sdk_path}/usr/bin/ncurses5.4-config"
    system "./autogen.sh"
    args = %W[
      --prefix=#{prefix}
      --bindir=#{bin}
      --libdir=#{libexec}
      --enable-curses
      --disable-ncursestest
      --disable-sdltest
      --disable-x11
      --with-ncurses-prefix=#{MacOS.sdk_path}/usr
    ]
    args << "--enable-sdl" if build.with? "sdl"

    system "./configure", *args
    system "make"
    system "make", "install"

    if build.with? "cocoa"
      cd "src" do
        system "make", "-f", "Makefile.osx"
      end
      prefix.install "Angband.app"
    end
  end

  test do
    system bin/"angband", "--help"
  end
end
