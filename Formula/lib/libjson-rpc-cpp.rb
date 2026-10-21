class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 7
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f1ad7639166b21e2239e8e7b8110bbaefe372559384bbbccf4bda11ce8c15ac5"
    sha256 cellar: :any, arm64_tahoe:       "412e9e3a4a8b544a4dc4e94d043a9ff2959f62018a2ab58eccca9facb2b91cee"
    sha256 cellar: :any, arm64_sequoia:     "b33984e457e4de15bcd53282622f9d4a1a98be7e95fee6f576b1122495bfbfb5"
    sha256 cellar: :any, arm64_linux:       "360d95dca66bb02af9feb3c604a21a5e87b0ed474e0c8e015065236c182f80e6"
    sha256 cellar: :any, x86_64_linux:      "181f02394257197acff843d8fbb79858f2cfec9d8b17f98cccffdf53eb6c616a"
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
