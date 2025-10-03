class Concurrentqueue < Formula
  desc "Fast multi-producer, multi-consumer lock-free concurrent queue for C++11"
  homepage "https://github.com/cameron314/concurrentqueue"
  url "https://github.com/cameron314/concurrentqueue/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "87fbc9884d60d0d4bf3462c18f4c0ee0a9311d0519341cac7cbd361c885e5281"
  license all_of: [
    { any_of: ["BSD-2-Clause", "BSL-1.0"] },
    "Zlib",
  ]

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "64a380746e2547d26f64b5ce8945cc4af4e0169a2dffdc89ebbb534dc5e0061e"
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
