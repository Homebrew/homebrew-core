class AtkmmAT228 < Formula
  desc "Official C++ interface for the ATK accessibility toolkit library"
  homepage "https://www.gtkmm.org/"
  url "https://download.gnome.org/sources/atkmm/2.28/atkmm-2.28.4.tar.xz"
  sha256 "0a142a8128f83c001efb8014ee463e9a766054ef84686af953135e04d28fdab3"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/atkmm-(2\.28(?:\.\d+)*)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:    "e8931497dd646ec78caf0f60b31040f777a584af67d3b46439f4811812c0645c"
    sha256 cellar: :any, arm64_sequoia:  "666a7ab1c48c5013fe80065747861be3df354221fd8f2dc4fa6fc312961f3edc"
    sha256 cellar: :any, arm64_sonoma:   "f456190b4929828e7786823167e1b49e017314b86018a02d5730921db647b61f"
    sha256 cellar: :any, arm64_ventura:  "9258ea3392df7963c73faaeebb0d1daa29bef3e3d29a2fb3ba0ec75d70a5be9b"
    sha256 cellar: :any, arm64_monterey: "0c6cab78734bf9ba2566cc9226d100ac78fc7b50e3576df09bdccdca3cd17995"
    sha256 cellar: :any, sonoma:         "23fc5fb3345c060262e193aa31f07fe347f297a3e365090d77697b0c3531111e"
    sha256 cellar: :any, ventura:        "d7e72faf7d1f8cec802a2cf3ffc36a24e0c763d7aa5c350796d1d49255fad66a"
    sha256 cellar: :any, monterey:       "d48e4769f508c8f4b3147fa598020da42d42cdce9ad5ac4377763f508d3e228b"
    sha256               arm64_linux:    "96e07ff462123e77d619943a5bba6ac854387c209a58547ecc7d772172521b44"
    sha256               x86_64_linux:   "fc9b8e9286aaf97bc9255158fae66cb4ea5c6a2c2c8f6cbb3681a69cd9fa39f3"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "at-spi2-core"
  depends_on "glib"
  depends_on "glibmm@2.66"
  depends_on "libsigc++@2"

  on_macos do
    depends_on "gettext"
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <atkmm/init.h>

      int main(int argc, char *argv[])
      {
         Atk::init();
         return 0;
      }
    CPP

    flags = shell_output("pkg-config --cflags --libs atkmm-1.6").chomp.split
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
