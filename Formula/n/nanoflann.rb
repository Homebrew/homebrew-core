class Nanoflann < Formula
  desc "Header-only library for Nearest Neighbor search with KD-trees"
  homepage "https://github.com/jlblancoc/nanoflann"
  url "https://github.com/jlblancoc/nanoflann/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "887e4e57e9c5fbf1c2937f9f5a9bc461c4786d54729b57a9c19547bdedb46986"
  license "BSD-3-Clause"
  head "https://github.com/jlblancoc/nanoflann.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2b8a65bce4034e3469bb21a3071f8e7f1f06338b777332c1edea6b66d3c68ddc"
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
    (testpath/"test.cpp").write <<~CPP
      #include <nanoflann.hpp>
      int main() {
        nanoflann::KNNResultSet<size_t> resultSet(1);
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-o", "test", "-std=c++11"
    system "./test"
  end
end
