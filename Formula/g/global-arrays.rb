class GlobalArrays < Formula
  desc "Partitioned Global Address Space (PGAS) library for distributed arrays"
  homepage "https://globalarrays.github.io/"
  url "https://github.com/GlobalArrays/ga/releases/download/v5.9.2/ga-5.9.2.tar.gz"
  sha256 "cbf15764bf9c04e47e7a798271c418f76b23f1857b23feb24b6cb3891a57fbf2"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80442594d07072d82f44fd596e5c600e32cb3323ecd8d69030450222493306d5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "426c2d6a96b66a43adaf73ab90b4ebffe52ba64de01ab72aa06d279ab74571a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7fa668a34db60ab92a8af3093aa1a639a482a5e9d8b3c4008a95e1c63b3c0e8b"
    sha256 cellar: :any_skip_relocation, sonoma:        "569b318d34df76a58dc52e1c959ba0afd50d2a230d5bff9c20757f83bb5edb4e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7d1a103bdd3fbc420638d69af603c621e4369298bfe9242210782353b6eac3fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbe1747a4dcc6ba882ebd19aba91348f34d1b2e9809caedf8f8d896b9f099cf3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "open-mpi"

  # Backport fix for the `ga++` library's CMake configuration
  patch do
    url "https://github.com/GlobalArrays/ga/commit/9f8d8fad67637c75c430a7a3ea887e4115482301.patch?full_index=1"
    sha256 "421d65a117ef3e53899c491ca5887360821170f0f9e735cc15a72efd9fe08882"
  end

  def install
    args = %w[-DENABLE_TESTS=OFF -DENABLE_FORTRAN=OFF]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(FormulaTest C CXX)
      find_package(GlobalArrays REQUIRED)
      add_executable(test test.c++)
      target_link_libraries(test PRIVATE GlobalArrays::ga++)
    CMAKE

    (testpath/"test.c++").write <<~CXX
      #include <ga/ga++.h>
      #include <iostream>

      int main(int argc, char* argv[])
      {
        GA::Initialize(argc, argv);
        if (0 == GA::nodeid())
          std::cout << GA::nodes();
        GA::Terminate();
      }
    CXX

    system "cmake", "."
    system "cmake", "--build", "."
    assert_equal "2", shell_output("mpirun -n 2 ./test")
  end
end
