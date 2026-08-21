class Immer < Formula
  desc "Library of persistent and immutable data structures written in C++"
  homepage "https://sinusoid.es/immer/"
  url "https://github.com/arximboldi/immer/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "b18b92ba60ec3186dc36ef671d3c2ae542cbb63eb6dc0e258476c6111a67c971"
  license "BSL-1.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9e8fb22791b14e5ff097df3c481289d5e87c31f5eb97f54c7e84fac00d93fbf1"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  def install
    args = %w[
      -Dimmer_BUILD_EXAMPLES=OFF
      -Dimmer_BUILD_EXTRAS=OFF
      -Dimmer_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "_build", *args, *std_cmake_args.reject { |s| s["-DBUILD_TESTING=OFF"] }
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <immer/vector.hpp>
      int main()
      {
          const auto v0 = immer::vector<int>{};
          const auto v1 = v0.push_back(13);
          assert(v0.size() == 0 && v1.size() == 1 && v1[0] == 13);

          const auto v2 = v1.set(0, 42);
          assert(v1[0] == 13 && v2[0] == 42);
      }
    CPP

    system ENV.cxx, "-std=c++14", "-I#{include}", "test.cpp", "-o", "test"
    system "./test"
  end
end
