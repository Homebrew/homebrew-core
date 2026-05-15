class Nsync < Formula
  desc "C library that exports various synchronization primitives"
  homepage "https://github.com/google/nsync"
  url "https://github.com/google/nsync/archive/refs/tags/1.30.0.tar.gz"
  sha256 "883a0b3f8ffc1950670425df3453c127c1a3f6ed997719ca1bbe7f474235b6cc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "34b5f37ee36a14b1e76e5052c2f593544e39d45acd8d7d7e0d90600226072802"
    sha256 cellar: :any,                 arm64_sequoia: "33fec4c6c42fbb8b09c8d3d0243f3730add7887e902d5bdb1608ed733843a75e"
    sha256 cellar: :any,                 arm64_sonoma:  "b347b136ba54882d203e7d0989e94347b9fb738feaa6c0059fa9bec7070fde0c"
    sha256 cellar: :any,                 sonoma:        "78b2f4271d03da7e849c0446837d338aceb66903a53bd9e89d8aeb559dda6f0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2f3bd67fa9e140561b815dcf454a09ee5950ca419fb5b5a49752558dc904be8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "70bf2bc57ecea6d5c4acc02275f360a67fc86ea714c2a76ebbbff1509453ef6f"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DNSYNC_ENABLE_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <nsync.h>
      #include <stdio.h>

      int main() {
        nsync_mu mu;
        nsync_mu_init(&mu);
        nsync_mu_lock(&mu);
        nsync_mu_unlock(&mu);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-lnsync", "-o", "test"
    system "./test"
  end
end
