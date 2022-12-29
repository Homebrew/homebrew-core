class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "fa3b0a67d82894d2766fe8c9081d8db18b92906754ad1073846185fbaf115634"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "7e9a16ae49c12c40204931af6c8969025c3ca9e7bbce69cf1d6e6c5e154abde0"
    sha256 cellar: :any, arm64_monterey: "af672badfe3e04b4e6d3117a11e02eca3629a9dc5dd9f29a6bf229f71d0c4825"
    sha256 cellar: :any, arm64_big_sur:  "4974c03558cf474c41fe23fd5f35133a495d0147313dd5e53fcf3ebc0594ab40"
    sha256 cellar: :any, ventura:        "ef7f4c9e910320ccd03ec36390fcf890ec604f789e36c5e1946d99faa1b646b1"
    sha256 cellar: :any, monterey:       "d5c9311ae450e25c00c791038108065ef84266e7dad87a8a76158c286892fc99"
    sha256 cellar: :any, big_sur:        "83cb22f7db289f77fa844ed5ebdb914bc5cb5697b5282bd0346a96469ea8b042"
    sha256 cellar: :any, catalina:       "7737aa0fb767697039141e37f276d0cdbdedc328d431b80bb0d0c2c97a74ed74"
    sha256               x86_64_linux:   "7688bf1df0466784f1cd798c9cf363226cb0611f5e82496eceacf090decdbc8c"
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
