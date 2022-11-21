class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.7.0.tar.gz"
  sha256 "df80d9439abf741c7d2fdcdfd2d26528b136e6c52976be8bd0cd5e45a27262c0"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 ventura:      "f70fec844e2ca2df114289c7231bcf0e3e100be11048a72487f6686ca73b25a5"
    sha256 cellar: :any,                 monterey:     "96d648cebc111c56cc4ce8d8c371dcfd61ec9a0b5ded7ade4f7382d2f6fbc2e7"
    sha256 cellar: :any,                 big_sur:      "f38f676b5869a9e36c57a6e06f0fc8406155e274f6fa6e40fa619d677ab6f2ed"
    sha256 cellar: :any,                 catalina:     "b0a9fe84986d1905ce1f05319e05b4b3f7b382c9816cdbec5107d6583845dca7"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "861a3a31b94d4f853f252f6b430fc20f4aba9aa704eb83c8b85a83478f3e8678"
  end

  depends_on "cmake" => :build
  depends_on arch: :x86_64 # https://github.com/google/cpu_features#whats-supported

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Install static lib too
    system "cmake", "-S", ".", "-B", "build/static", *std_cmake_args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libcpu_features.a"
  end

  test do
    output = shell_output(bin/"list_cpu_features")
    assert_match(/^arch\s*:/, output)
    assert_match(/^brand\s*:/, output)
    assert_match(/^family\s*:/, output)
    assert_match(/^model\s*:/, output)
    assert_match(/^stepping\s*:/, output)
    assert_match(/^uarch\s*:/, output)
    assert_match(/^flags\s*:/, output)
  end
end
