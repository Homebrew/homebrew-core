class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/refs/tags/v1.4.1.tar.gz"
  sha256 "7a057e50d6203e4ea0a10ba5e4dbf344c48b177e5a3bf82e850eb3a783c11eb5"
  license "MIT"
  revision 4
  head "https://github.com/cinemast/libjson-rpc-cpp.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6dc9f12a9b6bf936881daefc66364df558d40e4daa5ef1327313619b91e8ebd1"
    sha256 cellar: :any,                 arm64_sequoia: "437e579e259460e182a7a265ab31eda753c85860623d95fae1585c831ed26046"
    sha256 cellar: :any,                 arm64_sonoma:  "3c31da615d72e5b0b7fa8563a2f20ba614ae2149eedbdcc5e7b1bbf2ec4cf485"
    sha256 cellar: :any,                 arm64_ventura: "a50a022cd28c1afc756e6549255a779b0cc7e657de249492cee095c7414bf462"
    sha256 cellar: :any,                 sonoma:        "1a06d33fb6dfb02a77dff103df8c5dccaf31732f57c5084894a6bb8a990fd40f"
    sha256 cellar: :any,                 ventura:       "2b77b2e2ab126d3f5256ac54666ebc3bfaf0d039b9a204a94ccdf12e3adc2988"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "937c9426645552d0f435306f02dc4bea55498e2e6402c53d2bcbb5ab053c067c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e81e47b0e548b539d9be3449e951c2f8fbdd9274acfef193ca9a89e6255b67e"
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
