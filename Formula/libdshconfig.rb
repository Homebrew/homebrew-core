class Libdshconfig < Formula
  desc "Distributed shell library"
  homepage "https://www.netfort.gr.jp/~dancer/software/dsh.html.en"
  url "https://www.netfort.gr.jp/~dancer/software/downloads/libdshconfig-0.20.13.tar.gz"
  sha256 "6f372686c5d8d721820995d2b60d2fda33fdb17cdddee9fce34795e7e98c5384"

  bottle do
    cellar :any
    rebuild 1
    sha256 "82fc9db7c3ad20bdcd5681be1075ae4853b6f19caeb41624dac33d53470b2523" => :sierra
    sha256 "a26ea1d1cefed24fd890bbc65f9a11d171cdbcb1c00936562255e2adfe29205f" => :el_capitan
    sha256 "7f4e5e77fc14d6920bd212e9c812c7dad51ad1dbe1542f1c0e4999928db9ad3f" => :yosemite
    sha256 "c1c35337d7b2bebb59d07a8f792493f1da89f2701eae58d382bb24edfd2c73d3" => :mavericks
    sha256 "b02e3d90eb1b2a6ee33dd0b6c7648baf9dea117be5b111841ea3fdb98ba931b4" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
