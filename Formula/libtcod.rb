class Libtcod < Formula
  desc "API for roguelike developers"
  homepage "http://roguecentral.org/doryen/libtcod/"
  url "https://bitbucket.org/libtcod/libtcod/get/1.8.2.tar.bz2"
  sha256 "a33aa463e78b6df327d2aceae875edad8dba7a9e5ea0f1299c486b99f4bed31c"

  bottle do
    cellar :any
    sha256 "6376b266e1523c732e6465d50b988c8d7964e567f8ba27eeedb585217c1f1d87" => :mojave
    sha256 "40ec101abf6440dfcea154c4c57af89a0ec813cf99f810156e6bb53e27d22d14" => :high_sierra
    sha256 "ee03cac48e6b29dcf7c84860436ee61105fad31888d81791f4f519773e0d73b9" => :sierra
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
