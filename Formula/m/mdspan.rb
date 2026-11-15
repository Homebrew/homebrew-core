class Mdspan < Formula
  desc "Reference implementation of mdspan targeting C++23"
  homepage "https://github.com/kokkos/mdspan"
  url "https://github.com/kokkos/mdspan/archive/refs/tags/5.3.0.tar.gz"
  sha256 "ba71517536c646b9160c10e7d83e6aad5663e3289a1f619deb6a3760f252ffae"
  license "Apache-2.0" => { with: "LLVM-exception" }
  compatibility_version 1
  head "https://github.com/kokkos/mdspan.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d399e86060ce7fb382eab770752f8d56408da0b30bf2d3d0b80b235d23b4315"
  end

  depends_on "cmake" => [:build, :test]

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/tiled_layout/simple_tiled_layout.cpp", testpath/"test.cpp"

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)

      project(test LANGUAGES CXX)

      find_package(mdspan REQUIRED)
      add_executable(test test.cpp)
      target_link_libraries(test mdspan::mdspan)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "./build/test"
  end
end
