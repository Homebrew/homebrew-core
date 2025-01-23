class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 3
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b32795ebb2fb12dac9d2b3f6d348878d031b4fd870be80f130159da2f160e0ad"
    sha256 cellar: :any,                 arm64_sonoma:  "25f6d633b2383e5dc88a8dd4eb4fba128cef8d25bcd6ebf5e657846b1e8369ba"
    sha256 cellar: :any,                 arm64_ventura: "2f411e6903b995eab82f79c25a644198b6fed1df3e126bfbf8c7fe379dedb4a5"
    sha256 cellar: :any,                 sonoma:        "b82cf5eb7e5b47d4fd53f879f6a4799961498852462e4ce921ab973b9fa0fe52"
    sha256 cellar: :any,                 ventura:       "bf9d872537b6d70e320e458d73cd25f37a36ce8abeb5974e79477329888ed22d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87827ed159bb730d59df16863d4b1c6702e2c023b9abfb95b1e7309a59fdc24f"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    args = %w[
      -DCOMPILE_EXAMPLES=OFF
      -DCOMPILE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jsonrpcstub", "-h"
  end
end
