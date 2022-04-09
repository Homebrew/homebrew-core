class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "aafc8e5e9b122c4bde4370ee3f2ab8afb043f2a1547cacc062991ad420e3b9a4"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a522e2d270893e0abb9a24679444c7b1cea1fb09c19679ee28c908778b00d09f"
    sha256 cellar: :any,                 arm64_big_sur:  "bf96f8bf63e8dbb34cdf983c5281de60f5f62a6f356849194c357da99a5b2462"
    sha256 cellar: :any,                 monterey:       "b3f83fd0b36714ad82779de087fbeaeb42d3458def5da07f540f8f9e753e41c2"
    sha256 cellar: :any,                 big_sur:        "a5a2e84797108299fa6ebfc43ec6c9781abb3685a54025934f9e60a0a0721acd"
    sha256 cellar: :any,                 catalina:       "a8404a094ee40d02827c7f7bfa64409f2ede29ced343a3588b9c6f53df8c77f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25c62461eb2b5aa859f60f904b0fbd830a71b02a9edf349988427793ff7d88b8"
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
