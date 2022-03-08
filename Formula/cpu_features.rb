class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.7.0.tar.gz"
  sha256 "df80d9439abf741c7d2fdcdfd2d26528b136e6c52976be8bd0cd5e45a27262c0"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 monterey:     "43bd36cdcfd069f70a6aeed0b69d9d1bd530a9da640c3a76555bc6208a0c5ffa"
    sha256 cellar: :any,                 big_sur:      "c3364cf6afd756eb5fd6faf3b6dfd84daf2dd6884375e69d03f09d8a1de30448"
    sha256 cellar: :any,                 catalina:     "235e33e78650bccb4441c00c0244a72f40b1e63ef6c6c86e3a34c9d0aadd2e79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a5c78ef0f40b9357bd23610159a17f37db77d8934c7b23cdf773462aea790492"
  end

  depends_on "cmake" => :build

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
