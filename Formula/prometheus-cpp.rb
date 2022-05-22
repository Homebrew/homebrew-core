class PrometheusCpp < Formula
  desc "Prometheus Client Library for Modern C++"
  homepage "https://github.com/jupp0r/prometheus-cpp"
  url "https://github.com/jupp0r/prometheus-cpp.git",
      tag:      "v1.0.1",
      revision: "76470b3ec024c8214e1f4253fb1f4c0b28d3df94"
  license "MIT"
  head "https://github.com/jupp0r/prometheus-cpp.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87d558548dd4ad4d524b4258aab438e67b85d8ada77e5a3454c8763ca7cd4fb0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2166b03d24bd56a20e415db89ffecffa621908f39a04ee701cc9fd02ac7ecd9"
    sha256 cellar: :any_skip_relocation, monterey:       "0b903d8b4abab0c2862a88ef7216c1e8d6ac8f002a0e2cc67db64690825ad908"
    sha256 cellar: :any_skip_relocation, big_sur:        "d18c21cde436b1689154d821062bd879c9c8eb35170bb0222040dc53a02329f2"
    sha256 cellar: :any_skip_relocation, catalina:       "e245520c33f7a4fbebac3a38899f21f3e1114c62d73e5bdbd043435c3c0efa14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "252bfd884db18a5b743270fb5d51ef1450c5b4d153223d45b5df75efaaf24fc9"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"
  uses_from_macos "zlib"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <prometheus/registry.h>
      int main() {
        prometheus::Registry reg;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-I#{include}", "-L#{lib}", "-lprometheus-cpp-core", "-o", "test"
    system "./test"
  end
end
