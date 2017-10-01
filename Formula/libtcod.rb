class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.6.3.tar.bz2"
  sha256 "7bd3142bba45601f1159c6a092cbe9efefa3fe450418c0855d8edc4429d515b7"

  bottle do
    cellar :any
    sha256 "36ed32488096eede62f9ff1416feb35a0ea2c32df441218e657041bc8e888c58" => :high_sierra
    sha256 "04348552c6e7ea7b3d4f9093fa6f6c063dfa6965bcdc39c7c8ff86a3eadf8ac1" => :sierra
    sha256 "67f9bbe96cb955bccaacfe12c2d13705af17a107f03777a43e0b7b784aff1616" => :el_capitan
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
