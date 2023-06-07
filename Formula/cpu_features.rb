class CpuFeatures < Formula
  desc "Cross platform C99 library to get cpu features at runtime"
  homepage "https://github.com/google/cpu_features"
  url "https://github.com/google/cpu_features/archive/v0.8.0.tar.gz"
  sha256 "7021729f2db97aa34f218d12727314f23e8b11eaa2d5a907e8426bcb41d7eaac"
  license "Apache-2.0"
  head "https://github.com/google/cpu_features.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 ventura:      "b6c3ae68da8ffc33249b6c5631e021be42ca1bc6e947f4093386c0c185528137"
    sha256 cellar: :any,                 monterey:     "140e90dc4c7741d6b33f8bc038bbd68ed545312ee58e07697d8b57584e8762e0"
    sha256 cellar: :any,                 big_sur:      "3a9206c537847ccd89d6569c8db3125ccd345fe4369355c667e87ecb829097e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "842480ec53a47fc61a3ec7c994315425c2a0539671d757473e0e667982018573"
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
