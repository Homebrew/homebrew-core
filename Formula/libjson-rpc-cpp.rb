class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v0.7.0.tar.gz"
  sha256 "669c2259909f11a8c196923a910f9a16a8225ecc14e6c30e2bcb712bab9097eb"
  revision 1

  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "79bcde164706c2db62d785531a417e1b305a30e15f598ccb772dc68b3fe31069" => :sierra
    sha256 "0d65e52c1b6ab68811402080c4ceafd4f79f43260317a8700bc356e7af708fb2" => :el_capitan
    sha256 "01142f8d874457bcda6ba2d5d862988b25666c2f567a8ad66e8682d3f2416bd0" => :yosemite
    sha256 "3542b32c72e8c73b0ba13ccdb7552e65830e5f63ac4d8474d72f45c8219234af" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
