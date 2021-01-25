class Libdaemon < Formula
  desc "C library that eases writing UNIX daemons"
  homepage "http://0pointer.de/lennart/projects/libdaemon/"
  url "http://0pointer.de/lennart/projects/libdaemon/libdaemon-0.14.tar.gz"
  sha256 "fd23eb5f6f986dcc7e708307355ba3289abe03cc381fc47a80bca4a50aa6b834"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?libdaemon[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    rebuild 2
    sha256 "e33a72add1413b788a607ae16413c3434da9d2faca96b9201504121b03a7ff73" => :big_sur
    sha256 "d5bebb62e8788d3e229a9022c600d3abc7b93843c854070a6296e6962979a2f0" => :arm64_big_sur
    sha256 "ad96f0b0e09c3e0c178d3e903659d65ae34fea18365197924a4911c291d02531" => :catalina
    sha256 "1fe52d810eca4471b4d285de02a09ea9e4b78d762f1a2a292d6da1eb10e9626d" => :mojave
    sha256 "0933bb1dde0237f4079fefcd228ea644be36fbf814aa96762ebbae3537886558" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
