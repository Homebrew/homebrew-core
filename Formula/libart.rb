class Libart < Formula
  desc "Library for high-performance 2D graphics"
  homepage "https://people.gnome.org/~mathieu/libart/libart.html"
  url "https://download.gnome.org/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2"
  sha256 "fdc11e74c10fc9ffe4188537e2b370c0abacca7d89021d4d303afdf7fd7476fa"

  bottle do
    cellar :any
    sha256 "5fc8b240a975efcb5bd3992afd4d01c0a393a306a4a66192cb9a10e580bcf4d3" => :mojave
    sha256 "c5ae59f4955fd1b4e3c49976b06609d56c5079d2b0f6e0675b356b1eb09181cd" => :high_sierra
    sha256 "e9e14623ba0284a89dd09c7be72393619582c5d0489891cd1f654b6c26b0fabc" => :sierra
    sha256 "18fb7a842650151fef102efadefa52aa12dc3f597ace95b8e25efe6518a65d2e" => :el_capitan
    sha256 "006a9bf5e40ea99cdb4a10b7a2a2ac6a249f511254be1954a937dac0e50a6f0d" => :yosemite
    sha256 "276eafd432499ab988a21d9e87104d744e82cf1adf4cc55d47639b1f72ab410a" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
