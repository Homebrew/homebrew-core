class Buildcache < Formula
  desc "Advanced compiler accelerator"
  homepage "https://github.com/mbitsnbites/buildcache"
  url "https://github.com/mbitsnbites/buildcache/archive/refs/tags/v0.28.4.tar.gz"
  sha256 "bc6f47567e5079d1ec1c1b6992a2088af944c5b25ed5c176f51ccfcb2026a90c"
  license "Zlib"
  head "https://github.com/mbitsnbites/buildcache.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "src", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"hello.c").write <<~EOS
      #include <stdio.h>
      int main() {
        puts("Hello, world!");
        return 0;
      }
    EOS
    system "#{bin}/buildcache", "cc", "hello.c", "-o", "hello-c"
    assert_equal "Hello, world!", shell_output("./hello-c").chomp
  end
end
