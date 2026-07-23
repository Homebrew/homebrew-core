class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 6
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b7f8ed2efd15cc6f35428761c6354a684116c137850e5d878ce61e768d117ecb"
    sha256 cellar: :any, arm64_sequoia: "5585f289461a653af4910f3a7b4284ab4be73b9459dde38a7598ea522d8e0f43"
    sha256 cellar: :any, arm64_sonoma:  "57c8d3cc9e4d815700357b788435bc97a2ccdebea864b45a0a9ee0bd41d3ebc2"
    sha256 cellar: :any, sonoma:        "8cdec171f1ebcbcdf81a5b16e3c6455bd0139c6d4c7c74cd1559b40f2971d6ca"
    sha256 cellar: :any, arm64_linux:   "0ad30aa84d8e1c1c3a3ffec2fca43221accc269f6f41f3d0fd626b2f13d5fae2"
    sha256 cellar: :any, x86_64_linux:  "3bf887396ca51c1a8258ede205ef9141f1477337c44c3e2d381f9f2203e6ca93"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    # Fix to Policy CMP0042 may not be set to OLD behavior
    # because this version of CMake no longer supports it.
    # Issue ref: https://github.com/cinemast/libjson-rpc-cpp/issues/334
    inreplace "CMakeLists.txt", "cmake_policy(SET CMP0042 OLD)", ""
    args = %W[
      -DCOMPILE_EXAMPLES=OFF
      -DCOMPILE_TESTS=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"jsonrpcstub", "-h"
  end
end
