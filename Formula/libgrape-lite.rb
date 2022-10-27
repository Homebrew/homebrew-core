class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.2.2.tar.gz"
  sha256 "54edc90a3116e0c1e91dd0027c6d9a1c9f95d1d0c8ded8ca9219b3c16d3a2f5d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "d5ce7747e1d1b029ff6a2ac1e5f4a284ae234a2a052e3f5d64b04707db9e9502"
    sha256 cellar: :any, arm64_monterey: "83f192293edd96693e82f70371fff632725ab9f9ae3d63abeed1c5d2ad113026"
    sha256 cellar: :any, arm64_big_sur:  "c5cfbf25cf3a3991c6cacb5b9b6ef6455fb65a54dfa4c26b1b6909d2f5c599d7"
    sha256 cellar: :any, monterey:       "780b15e69886c16faef1c6c609865144cb8d623a4763f3f8a3e0be285fa6e5e3"
    sha256 cellar: :any, big_sur:        "cc108f25de00b8089fc0af337892695482abcdab1168a8b190f3a32ad0de9ce4"
    sha256 cellar: :any, catalina:       "4005982d761648d539b3a14f10222cdba9101f85ec605db090987a2c1f88741c"
    sha256               x86_64_linux:   "317f866c76376454c49b2d26434b212a01780c93aa9ef50f065235ea7feb23f2"
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
