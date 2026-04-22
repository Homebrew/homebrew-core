class AtomicQueue < Formula
  desc "C++14 lock-free queues"
  homepage "https://github.com/max0x7ba/atomic_queue"
  url "https://github.com/max0x7ba/atomic_queue/archive/refs/tags/v1.8.1.tar.gz"
  sha256 "57880b536f81c12903dfdc5aa25e3187e67cd56657f005f0be75084a00614958"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08b52539483c0ae231cf5348d12141bd8bb9696b3db839ec4d5edcb2bfdc380e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b52539483c0ae231cf5348d12141bd8bb9696b3db839ec4d5edcb2bfdc380e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08b52539483c0ae231cf5348d12141bd8bb9696b3db839ec4d5edcb2bfdc380e"
    sha256 cellar: :any_skip_relocation, sonoma:        "08b52539483c0ae231cf5348d12141bd8bb9696b3db839ec4d5edcb2bfdc380e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "163b953e704f5d42ad66a3f9b0f6d52ffed41b7e2ad98ff0e165d344e394738e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "163b953e704f5d42ad66a3f9b0f6d52ffed41b7e2ad98ff0e165d344e394738e"
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
