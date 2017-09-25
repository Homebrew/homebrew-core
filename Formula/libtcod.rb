class Libtcod < Formula
  desc "API for roguelike developpers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.6.3.tar.bz2"
  sha256 "7bd3142bba45601f1159c6a092cbe9efefa3fe450418c0855d8edc4429d515b7"

  bottle do
    cellar :any
    sha256 "1c87548bf17dfd58392f7da311b312c7f081239457aaff986bfefb4086847855" => :high_sierra
    sha256 "ccad47287c9a34afcffa48d6b8f469cb729a1133f95f44be0fe7a1506723980f" => :sierra
    sha256 "65cf5860b8325fe352f497ad287303c4a725e623d1a64c45c879463a36603f51" => :el_capitan
    sha256 "de169860f67c2be9d4ed7770f682700b31642030da1b50583b26b53e5e514bfe" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl2"

  conflicts_with "libzip", :because => "both install `zip.h` header"

  def install
    cd "build/autotools" do
      system "autoreconf", "-fiv"
      system "./configure"
      system "make"
      lib.install Dir[".libs/*{.a,.dylib}"]
    end
    include.install Dir["include/*"]
    # don't yet know what this is for
    libexec.install "data"
  end
end
