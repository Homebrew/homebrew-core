class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "3dd601484a6ef5635ea520c56bca3a029fba382e8aacf3d8d23d12a813defb1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3659ebee323f96fb3eb64094d02692738d18e235845d7303317d6022636ec3af"
    sha256 cellar: :any,                 arm64_big_sur:  "9600dc934d922dd409aaf2cca9ade069864a867fa7b44fc89ca23689c047fb8b"
    sha256 cellar: :any,                 monterey:       "84bd889b150876d23ba0b3834e1dd0660662fb80958ec17f136490da91af3b24"
    sha256 cellar: :any,                 big_sur:        "5a4e474df5364687ce70746539b89d9777be651367906cc8011bd8858356ffa4"
    sha256 cellar: :any,                 catalina:       "9c60844dfd8d599b39768fdec71a803ebb3911dc7c2b108ccedfee5d3ecafc11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ca45dbd81d2069065fb46ef4c10a709d8977bd97dceb3a365c896d5872981164"
  end

  depends_on "cmake" => :build

  depends_on "glog"
  depends_on "open-mpi"

  def install
    ENV.cxx11

    system "cmake", "-S", ".", "-B", "build",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <grape/grape.h>

      int main() {
        // init
        grape::InitMPIComm();

        {
          grape::CommSpec comm_spec;
          comm_spec.Init(MPI_COMM_WORLD);
          std::cout << "current worker id: " << comm_spec.worker_id() << std::endl;
        }

        // finalize
        grape::FinalizeMPIComm();
      }
    EOS

    system ENV.cxx, "test.cc", "-std=c++11",
                    "-I#{Formula["glog"].include}",
                    "-I#{Formula["open-mpi"].include}",
                    "-I#{include}",
                    "-L#{Formula["glog"].lib}",
                    "-L#{Formula["open-mpi"].lib}",
                    "-L#{lib}",
                    "-lgrape-lite",
                    "-lglog",
                    "-lmpi",
                    "-o", "test_libgrape_lite"

    assert_equal("current worker id: 0\n", shell_output("./test_libgrape_lite"))
  end
end
