class Libecpint < Formula
  desc "Library for the efficient evaluation of integrals over effective core potentials"
  homepage "https://github.com/robashaw/libecpint"
  url "https://github.com/robashaw/libecpint/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "080e3176c7fb6d761f14ae585022e1fd070c26c70ec9e38641b6f17608cb09d0"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "eceda5d6f40c9ddd0122b527f9f613d6d580c49c797253d2559942fe67d0c7c9"
    sha256 cellar: :any,                 arm64_tahoe:       "a5d5b23e49813b83e94c2db21f568761f730637fb53dd094b44a4d5ebc66300b"
    sha256 cellar: :any,                 arm64_sequoia:     "c52edb64ef2f58d2917ed6c23b673ba7a91e235d5f484dd33f5b09aa667d165a"
    sha256 cellar: :any,                 arm64_sonoma:      "ddfb7be7a3099e1b6f55f39207977de575a8073143259a1bc4f9ee1ab4f4618e"
    sha256 cellar: :any,                 arm64_ventura:     "d925cc07595e0fc312ff86fdcdbed3e9952a0c6cb097152d7c54ce9de46b6587"
    sha256 cellar: :any,                 sonoma:            "a6f706be76c6675f4ec6ae3e4745557764273336a650c6dd35272f07221c35bf"
    sha256 cellar: :any,                 ventura:           "a0f40b815e0a8c17a5afaee0f7fc302cada2bebadccbd016a684001b03e964fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "beadc5b890d76cc2a78af3a2d848dd5b647b9287bb38d38ce81affc88aa2ebf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "87eb0928e103b94c921b2a7dc1c12b0e12033e917f67ba0b01d2015af1d126b9"
  end

  depends_on "cmake" => :build
  depends_on "libcerf"
  depends_on "pugixml"

  uses_from_macos "python" => :build

  deny_network_access!

  def install
    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DLIBECPINT_USE_CERF=ON",
      "-DLIBECPINT_BUILD_TESTS=OFF",
      "-DPython_EXECUTABLE=#{which("python3")}",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"example").install "example/example.cpp", "example/hydrogen.bas", "example/iodine.bas"
  end

  test do
    cp pkgshare.glob("example/*"), testpath
    system ENV.cxx, "-std=c++17", "example.cpp", "-I#{include}", "-L#{lib}", "-lecpint", "-o", "example"
    output = shell_output("./example #{pkgshare}")
    assert_match "Basis read: 44, 12, 36", output
    assert_match "Done.", output
  end
end
