class Angband < Formula
  desc "Dungeon exploration game"
  homepage "https://rephial.org/"
  url "https://rephial.org/downloads/4.1/angband-4.1.3.tar.gz"
  sha256 "9402c4f8da691edbd4567a948c5663e1066bee3fcb4a62fbcf86b5454918406f"
  head "https://github.com/angband/angband.git"

  bottle do
    sha256 "9f122623c5ef12aecc045f865527bbb85100aa192beab072ea5952574a8377d8" => :mojave
    sha256 "5659320a3de2e2f84b8dbbb385802ac18e7e80ad53c7aa6d0ae44d5ccbac6faa" => :high_sierra
    sha256 "b212186bf04d009ac2c6a16bbceda9cdad23fa7eb9b61f4567ff3971b8de6873" => :sierra
    sha256 "48e336d2c27873aa53c976460346f7523f0b12dbf1939e89c428af4ee95dfa73" => :el_capitan
  end

  option "with-cocoa", "Install Cocoa app"

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
