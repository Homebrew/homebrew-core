class Concurrentqueue < Formula
  desc "Fast multi-producer, multi-consumer lock-free concurrent queue for C++11"
  homepage "https://github.com/cameron314/concurrentqueue"
  url "https://github.com/cameron314/concurrentqueue/archive/refs/tags/v1.0.5.tar.gz"
  sha256 "4d6368a27492d86011fde5ca0cf386dce7c49cd425aa3d9b063ca6ec373a6ef3"
  license all_of: [
    { any_of: ["BSD-2-Clause", "BSL-1.0"] },
    "Zlib",
  ]

  bottle do
    sha256 cellar: :any_skip_relocation, all: "627800ae0b728b9f2064ac6ff8ffe1cd7c26d094a0bac6be9459ce48ebf666ca"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <concurrentqueue/moodycamel/concurrentqueue.h>
      int main() {
        moodycamel::ConcurrentQueue<int> q;
        q.enqueue(25);
        return 0;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test"
    system "./test"
  end
end
