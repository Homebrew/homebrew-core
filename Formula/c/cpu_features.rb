class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "ab2463f2d38fcaff1ce806be8e4c91333449931f5e02009d543b2569a3fa471a"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a7ab8c99995cba65930e1ecc83f5687241a3b25b4df82b8065fa4dd1edf5cff7"
    sha256 cellar: :any, arm64_sequoia: "1a45dbccd31a7053940f2a93560070bd13104faa0ce4eb02d464c6a433f56af4"
    sha256 cellar: :any, arm64_sonoma:  "bf4a0cf63357f1a3dd0c284210a1a95a635f054759ef7b159df297faa4f9b4db"
    sha256 cellar: :any, sonoma:        "0eb6810aab2db0910562d3a3ab9e365b2efd9ee06cc5bc9bdd1f5470483f5d5f"
    sha256 cellar: :any, arm64_linux:   "1bda3921c1343fb64aaad8831d7deb95887c885be722e661fbb39f2cb994a46e"
    sha256 cellar: :any, x86_64_linux:  "7928047db2b237c171a0f9541c721b19cae998c92483427f71eb8c0df7b553b9"
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
    if Hardware::CPU.arm?
      assert_match(/^implementer\s*:/, output)
      assert_match(/^variant\s*:/, output)
      assert_match(/^part\s*:/, output)
      assert_match(/^revision\s*:/, output)
    else
      assert_match(/^brand\s*:/, output)
      assert_match(/^family\s*:/, output)
      assert_match(/^model\s*:/, output)
      assert_match(/^stepping\s*:/, output)
      assert_match(/^uarch\s*:/, output)
    end
    assert_match(/^flags\s*:/, output)
  end
end
