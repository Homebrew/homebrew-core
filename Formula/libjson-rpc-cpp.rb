class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.2.0.tar.gz"
  sha256 "485556bd27bd546c025d9f9a2f53e89b4460bf820fd5de847ede2539f7440091"
  revision 2
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    cellar :any
    sha256 "caac08df49f703a5244f28b2d14c7197c8eac3ee4b7f246a395da7fe8aab0b2b" => :mojave
    sha256 "e025c59a1ede9c963bdc25b549a3104422303a78d8be2f7e528721e31588ae22" => :high_sierra
    sha256 "8db4c385b4e82d51be5bbff54538141284291982211fae00481a948e5a4b0d47" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
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
