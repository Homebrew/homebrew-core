class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/v0.3.0.tar.gz"
  sha256 "ceb56d6cab81b8ed2d812e4a546036a46dd28685512255e3f52553ba70a15fc8"

  bottle do
    cellar :any
    sha256 "54055df2b3b0431ba1903eed2f2abf7de05a368b7b8e7660158ef9a7ba2c9bcd" => :sierra
    sha256 "45a5e0e42d835e175ff923fc3e2c9fe75a25d5e9c6cc24dd1449622bc0a82d01" => :el_capitan
    sha256 "7535a016ea3e2e1ab59f452d11feeed4b287591c566a08d0c0c3680f8b2e1239" => :yosemite
    sha256 "6d6fd22aa6da55eef0eb939aebf4a5ec17c5e3ad101bc5c3132213b573d265d7" => :mavericks
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
