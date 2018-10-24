class Itpp < Formula
  desc "Library of math, signal, and communication classes and functions"
  homepage "https://itpp.sourceforge.io"
  url "https://downloads.sourceforge.net/project/itpp/itpp/4.3.1/itpp-4.3.1.tar.bz2"
  sha256 "50717621c5dfb5ed22f8492f8af32b17776e6e06641dfe3a3a8f82c8d353b877"
  head "https://git.code.sf.net/p/itpp/git.git"

  bottle do
    cellar :any
    sha256 "cc0a4a3787d616440ff284f97f87742327a5293b439195143a909b7764eb3ae4" => :mojave
    sha256 "357a4ee1ed9d2c7509a8ae7a22bda393942c6c40d56dc60468fdeec39b675ad5" => :high_sierra
    sha256 "168b61ba02bd54e625ccbcac998595dc2e96a4210a0709a7b7296a8ed9b985b5" => :sierra
    sha256 "c9f2f041dbdbea87029180a253fa0cd470aee6a2144a848b10f9fb5c40f01b8e" => :el_capitan
    sha256 "6e772c61104760fcf2c9500fa06fb2d032d4db1f53ef44d090e18aca54ee75f0" => :yosemite
    sha256 "c9e5ed1ab5febb67c61139b451ac70c501e6dd8fe656f7658d9e6aaa3f025e2a" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    mkdir "build" do
      args = std_cmake_args
      args.delete "-DCMAKE_BUILD_TYPE=None"
      args << "-DCMAKE_BUILD_TYPE=Release"
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
  end
end
