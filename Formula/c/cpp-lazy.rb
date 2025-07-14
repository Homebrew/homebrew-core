class CppLazy < Formula
  desc "C++11 (and onwards) library for lazy evaluation"
  homepage "https://github.com/Kaaserne/cpp-lazy"
  url "https://github.com/Kaaserne/cpp-lazy/archive/refs/tags/v8.0.1.tar.gz"
  sha256 "b237a7df04006f62c19eedaf7adbf9eb8d4dd4fd3daee39ca13d3aac97254f90"
  license "MIT"
  head "https://github.com/Kaaserne/cpp-lazy.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e28490a02ee004b28f274c2bf585135b73cd5f4c92bf2d7e51cf17f6175d2ec7"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :test
  depends_on "pkgconf" => :test

  def install
    args = %w[
      -DCPP-LAZY_USE_STANDALONE=ON
    ]

    system "cmake", "-S", ".", "-B", "builddir", *args, *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <cpp-lazy/Lz/Map.hpp>

      int main() {
        std::array<int, 4> arr = {1, 2, 3, 4};
        std::string result = lz::map(arr, [](int i) { return i + 1; }).toString(" "); // == "1 2 3 4"
      }
    CPP
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["fmt"].opt_lib/"pkgconfig"
    cxxflags = shell_output("pkg-config --cflags fmt").strip
    ldflags = shell_output("pkg-config --libs fmt").strip
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test", *cxxflags.split, *ldflags.split
    system "./test"
  end
end
