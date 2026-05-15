class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://github.com/max0x7ba/atomic_queue"
  url "https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.9.1.tar.gz"
  sha256 "f488e320a028428d8e7f908ca8e4fdf948431d5a26273b8a25f288246f8ae374"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdedca16ed542444e893fce138d6eb761416e249b2bb03ce911d700061ed8034"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdedca16ed542444e893fce138d6eb761416e249b2bb03ce911d700061ed8034"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdedca16ed542444e893fce138d6eb761416e249b2bb03ce911d700061ed8034"
    sha256 cellar: :any_skip_relocation, sonoma:        "bdedca16ed542444e893fce138d6eb761416e249b2bb03ce911d700061ed8034"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cb57248343bbeec7d6aa12ba8323003d2d5d0a28ef706c29ff1ddc3b3a82de5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb57248343bbeec7d6aa12ba8323003d2d5d0a28ef706c29ff1ddc3b3a82de5e"
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
