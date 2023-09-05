class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.3.tar.gz"
  sha256 "d1cc7dfe9aa31c5c6204b596eff61c1264c64fefdbbee7e696e4d02b008c38a7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a9b79a3bf8a9ae9961ff2f0805b00ba9bf8571918c7a2adae4dd604173f9df6f"
    sha256 cellar: :any,                 arm64_monterey: "bd40e857921df7aa153a1b05c5ed23013222fddda281a0d94d372fc0c7fc8262"
    sha256 cellar: :any,                 arm64_big_sur:  "9893f00e52ae2b86d7033c29d31b9b28d8045befb37dfee55ded052fb7550367"
    sha256 cellar: :any,                 ventura:        "ead05d4c7a8fb7062962f8310f24d41c55d6d119deb8ed58f308ffb32e087e85"
    sha256 cellar: :any,                 monterey:       "d623862fb74ff45161bcb58106de4b805256e8b1ee34b5dbd48f04065124463f"
    sha256 cellar: :any,                 big_sur:        "e2476cc0325ef33e6a6fc58bedba1cfeef29f5937cd5f652b01a5829d5a60706"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239d3dd775fec4fb88c81b2d741504df4f7022b0d2c437daee71ad5096744884"
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
