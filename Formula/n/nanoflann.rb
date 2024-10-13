class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search with KD-trees"
  homepage "https://github.com/jlblancoc/nanoflann"
  url "https://github.com/jlblancoc/nanoflann/archive/refs/tags/v1.6.1.tar.gz"
  sha256 "e258d6fd6ad18e1809fa9c081553e78036fd6e7b418d3762875c2c5a015dd431"
  license "BSD-3-Clause"
  head "https://github.com/jlblancoc/nanoflann.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e76ab573a8a142d781fec5075ee518d39a9dc5f77efa55fcd6a128df43d1ba91"
  end

  depends_on "cmake" => :build

  on_macos do
    depends_on "gcc" => [:build, :test] if DevelopmentTools.clang_build_version <= 1200
  end

  fails_with :clang do
    build 1200
    cause "https://bugs.llvm.org/show_bug.cgi?id=23029"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DNANOFLANN_BUILD_EXAMPLES=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
