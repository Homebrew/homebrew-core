class AsyncSimple < Formula
  desc "Simple, light-weight and easy-to-use asynchronous components"
  homepage "https://github.com/alibaba/async_simple"
  url "https://github.com/alibaba/async_simple/archive/refs/tags/1.4.tar.gz"
  sha256 "6188f7a5f4211754fee758dfebf73759b74ce78c208719b5cc37d5ab4775d550"
  license "Apache-2.0"
  head "https://github.com/alibaba/async_simple.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ea3f1e248db7c9bbaf801186303a6c6e633476b1fb0c0e6553642c46abc191ad"
    sha256 cellar: :any,                 arm64_sequoia: "582aee9fb04f0106f59850ef5001c8fb830da5f16ecfc60e6ee0b37de2c10c15"
    sha256 cellar: :any,                 arm64_sonoma:  "ad0185e500e7a4873138ffb48dbf0a0ad9d6ac7298fb3418006b8ecd6df8ba34"
    sha256 cellar: :any,                 arm64_ventura: "518f0229d7a19797fd5626fab507e608c7b25cc3bdfac3c05577d491c4923996"
    sha256 cellar: :any,                 sonoma:        "96069ca4876ed9bc04149fe02cc2445f3434a1dd84ae4360e4e420950a6d8e8c"
    sha256 cellar: :any,                 ventura:       "13c8d498f0ef0dd957353666f689f42bb9f94c262ab2997094699ec961362197"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3207af424eb85ff7a9d5c617b4c713262433024595a09d01e4d213328ae92bda"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "20cb19de4276e5664a529b84494d3109488ca7970bee8912d502066bb899d188"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCMAKE_CXX_STANDARD=20
      -DBUILD_GMOCK=OFF
      -DBUILD_GTEST=OFF
      -DINSTALL_GTEST=OFF
      -DASYNC_SIMPLE_BUILD_DEMO_EXAMPL=OFF
      -DASYNC_SIMPLE_ENABLE_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath / "test.cpp").write <<~CPP
      #include <algorithm>
      #include <async_simple/coro/Lazy.h>
      #include <async_simple/coro/SyncAwait.h>
      #include <iostream>
      #include <string>
      #include <vector>

      using namespace async_simple::coro;

      using Texts = std::vector<std::string>;

      Lazy<int> CountLineChar(const std::string& line, char c) {
        auto ret = std::count(line.begin(), line.end(), c);
        co_return static_cast<int>(ret);
      }

      auto main() -> int {
        auto num = syncAwait(CountLineChar("axxxax", 'x'));
        std::cout << num << std::endl;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++20", "-L#{lib}", "-lasync_simple", "-o", "test"
    assert_equal "4", shell_output("./test").chomp
  end
end
