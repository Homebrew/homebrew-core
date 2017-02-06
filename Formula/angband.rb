class Angband < Formula
  desc "Dungeon exploration game"
  homepage "http://rephial.org/"
  url "http://rephial.org/downloads/4.0/angband-4.0.5.tar.gz"
  sha256 "0d769a0f349842b0c78cbcd1804a9e08f064e75ca26b957710e4c2a3eb14f852"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "7210ffb906d29fbe201b6da58b2d8886286499eb08941af36677202c01b950ff" => :el_capitan
    sha256 "a2f85f11478a21dab43c83c8f4174cc5c2be1378000944b4adf93ac66a035bc4" => :yosemite
    sha256 "6e6d73ca3026a6f2100a1c60005efcb5c938405365dbf9f70927e29c5bb3c7ba" => :mavericks
  end

  option "with-cocoa", "Install Cocoa app"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :x11 => :optional
  depends_on "homebrew/dupes/tcl-tk" => "with-x11" if build.with? :x11
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
      --with-ncurses-prefix=#{MacOS.sdk_path}/usr
    ]
    args << "--disable-x11" if build.without? :x11
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
