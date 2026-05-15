class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 5
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "90009f5dccd487daf8353a4e34d46cc7e2b4dc88261daa2cfd73269685686613"
    sha256 cellar: :any,                 arm64_sequoia: "258f462530444dda7c57ba05dff26d861a7f4779e1f932b13be8fcc7383bd6fd"
    sha256 cellar: :any,                 arm64_sonoma:  "c9310d16222ac14c96de196af4c598064e47a5ced65280743c1036709fc72264"
    sha256 cellar: :any,                 sonoma:        "b13814601b1409b3d2bd6a2b714adb238c0853efe75cdb06a80bb657843c5c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af46b21b0d61e4ed19640672030c305c8a368bce66e9a43582fc61455d9a171e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e25df228081f30d9cab7785837ef4354978d11007ad815a61fdad087e6fea536"
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
