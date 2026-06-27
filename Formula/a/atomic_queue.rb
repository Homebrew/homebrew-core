class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://max0x7ba.github.io/atomic_queue/html/benchmarks.html"
  url "https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.9.2.tar.gz"
  sha256 "7c3606f23cea69d39c3872996ffb83587bd4ab08da3c0c4c45aba7aa15eea9f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f15fac605dba4db11eac46892b77f7ece83f6cf789477e74ad4438021b97d638"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f15fac605dba4db11eac46892b77f7ece83f6cf789477e74ad4438021b97d638"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f15fac605dba4db11eac46892b77f7ece83f6cf789477e74ad4438021b97d638"
    sha256 cellar: :any_skip_relocation, sonoma:        "f15fac605dba4db11eac46892b77f7ece83f6cf789477e74ad4438021b97d638"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc852d1260a179f50f475b3955d04fe0556468aea893723317ba93a9d455e466"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dc852d1260a179f50f475b3955d04fe0556468aea893723317ba93a9d455e466"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :test

  def install
    system "meson", "setup", "build", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cassert>
      #include <memory>
      #include <atomic_queue/atomic_queue.h>

      int main() {
          using QueueT = atomic_queue::AtomicQueueB2<int, std::allocator<int>, true, true, true>;
          auto queue = QueueT(64);
          queue.push(5);
          assert(queue.was_size() == 1);
          assert(queue.pop() == 5);
          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs atomic_queue").chomp.split
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++14", *flags
    system "./test"
  end
end
