class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.9.0.tar.gz"
  sha256 "bdb3484de8297c49b59955c3b22dba834401bc2df984ef5cfc17acbe69c5018e"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 sonoma:       "ce5c30e2f2fb534de048b4cab44164aa10ff0edc78fc2a1f980bd66dd0efd840"
    sha256 cellar: :any,                 ventura:      "330ff6e1dd7b1ba7d437ae26c190cef2c16a378dfde46c91c9c9f467c8ce6f02"
    sha256 cellar: :any,                 monterey:     "005e2f8cd05493e50e9633a328f67bff007013632ff113b0e61c4274c8a921e3"
    sha256 cellar: :any,                 big_sur:      "3eadb78e89e4aa6ad69a691495c45ad80a89308f56fdac9f33b24fa5114bb13b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "509a559426e4580b555e02fe7c38737012faf590477cc44845b11d714f5da8c3"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on arch: :x86_64 # https://github.com/google/cpu_features#whats-supported
  end

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
