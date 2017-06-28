class Angband < Formula
  desc "Dungeon exploration game"
  homepage "http://rephial.org/"
  url "http://rephial.org/downloads/4.1/angband-4.1.0.tar.gz"
  sha256 "ea52266e52b66d6bf2ab3728b3bc6c7c3875130973430021e31bf56000c0df8b"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "87585187f01fa753e59d6b6f804c1436c96c356c6f82878d5f57c3e54d80d4ce" => :sierra
    sha256 "4aa7a0f0218a488f89b5b6a8068d51f32c6331f02aaf360c35690e52f0d337ff" => :el_capitan
    sha256 "0733eb9c331522191a5017cf3fa3d20c5acb9da308db825bd9aba7dba43b3b3f" => :yosemite
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
