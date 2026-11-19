class Libecpint < Formula
  desc "Library for the efficient evaluation of integrals over effective core potentials"
  homepage "https://github.com/robashaw/libecpint"
  url "https://github.com/robashaw/libecpint/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "080e3176c7fb6d761f14ae585022e1fd070c26c70ec9e38641b6f17608cb09d0"
  license "MIT"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f25d9acf57439672db8cf9065bd65651e3d697ae82339eeaf3052c8792e2b6a9"
    sha256 cellar: :any, arm64_tahoe:       "44f7a089df2478520358c2735eb716a52085286619febfb5336eae43e5ac94af"
    sha256 cellar: :any, arm64_sequoia:     "9b314e0990d9f1e3ffd3cbe14d5860c8581f91298a9a046d3af6d16e3e9c00a7"
    sha256 cellar: :any, arm64_linux:       "488a6ab44343e1ca4f74b9555d7788448e1cba59071a427f6f5f515ddb968313"
    sha256 cellar: :any, x86_64_linux:      "e302935540459779a03f1269af40091f4e9918304857aebf2cef4b98fbeaf9b5"
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
