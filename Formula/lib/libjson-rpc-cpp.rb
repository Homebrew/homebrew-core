class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 2
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c8bcae7683868e7ec575bcffd0040b2a349e38edb08351fea9338f7ee91fe7dc"
    sha256 cellar: :any,                 arm64_monterey: "9cb86e8039e8e571b73ed1638c793f9b28592f892db42ce7279fbea76b729cc2"
    sha256 cellar: :any,                 arm64_big_sur:  "0328e51375b19212c2a10d4d350f6a4cd70a4e971fdfc692917f49de8fed4ad2"
    sha256 cellar: :any,                 ventura:        "ee599c61bbb42880d8312eadddf3ac23d2d4a0bd6b3db320c054b13e4158e7b4"
    sha256 cellar: :any,                 monterey:       "8a4a0c85641f6bb3cb1f0a94f8848bfd91c96974afd90f37005e58b718677551"
    sha256 cellar: :any,                 big_sur:        "ee8fe30830a557f91d0802ca338fa0d0953965ce09c6c3a61cceb05c053ec727"
    sha256 cellar: :any,                 catalina:       "a7df384528a1aa939fc7292e6baf3229ce1fd4bde42def2bdd4ae7692f3792f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c56cf094d5bc4ad8e7d3638d17d4e5c6120b8039f2889d89d5bf54286bed2910"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
