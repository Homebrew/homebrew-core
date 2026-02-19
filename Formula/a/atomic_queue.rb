class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://github.com/max0x7ba/atomic_queue"
  url "https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "6eeff578f8b0499717bf890d90e2c58106ac2b8076084b73f2183a631742b4ab"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b1149a3911cea1bd45fb204530cedb7f6ff684dc73aff53fac24fbbcfab88861"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b1149a3911cea1bd45fb204530cedb7f6ff684dc73aff53fac24fbbcfab88861"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1149a3911cea1bd45fb204530cedb7f6ff684dc73aff53fac24fbbcfab88861"
    sha256 cellar: :any_skip_relocation, sonoma:        "b1149a3911cea1bd45fb204530cedb7f6ff684dc73aff53fac24fbbcfab88861"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1bc3490122a06d18acb763f3bd9a76d098380aaf2d4e753a75771d714e5a228b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bc3490122a06d18acb763f3bd9a76d098380aaf2d4e753a75771d714e5a228b"
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
