class AsyncSimple < Formula
  desc "Simple, light-weight and easy-to-use asynchronous components"
  homepage "https://github.com/alibaba/async_simple"
  url "https://github.com/alibaba/async_simple/archive/refs/tags/v1.3.tar.gz"
  sha256 "0ba0dc3397882611b538d04b8ee6668b1a04ce046128599205184c598b718743"
  license "Apache-2.0"
  head "https://github.com/alibaba/async_simple.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "755cd0582500b20090528bb4192041eb7a57e2b1ba4fb87ecfe1082926c77415"
    sha256 cellar: :any,                 arm64_sonoma:  "e89443db479ff1e8aabc39e482f1c4cb72b3214a485588c0d461a21342fa9197"
    sha256 cellar: :any,                 arm64_ventura: "9563803b43de1611be1f4f38083535f9ea944907a4b07808e67400448096a52e"
    sha256 cellar: :any,                 sonoma:        "3e19085474250b8f93b361127483b8fa68e509d0c1e4132976090279bf746429"
    sha256 cellar: :any,                 ventura:       "4b9d30e6cc11876a60fe9180ae43ef4de77b21c3d49c789b2f5a6d73be8048be"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0892f76a0d09c6b8651a4ad677516adbb942bf9b376a867f63b3a5d7c23d0d12"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31cccc38ea016889db7f4a52700115a22d5eb7432e403c6939ef8bafb12bdd8e"
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
