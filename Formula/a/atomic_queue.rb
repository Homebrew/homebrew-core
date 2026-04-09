class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://github.com/max0x7ba/atomic_queue"
  url "https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.7.3.tar.gz"
  sha256 "8502effdbf580426bda77b258ec0e2e0d69be55ebeb874886ef86f84cc7d5a50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3a1f9619f5c9e07ad89374dc1725521f87dcca9d54041602345114ff67e532de"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a1f9619f5c9e07ad89374dc1725521f87dcca9d54041602345114ff67e532de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3a1f9619f5c9e07ad89374dc1725521f87dcca9d54041602345114ff67e532de"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a1f9619f5c9e07ad89374dc1725521f87dcca9d54041602345114ff67e532de"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d9c6f73913a49c03716892e85d5a2da94f9f7805f98345e7ba70f300cb49cfd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d9c6f73913a49c03716892e85d5a2da94f9f7805f98345e7ba70f300cb49cfd"
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
