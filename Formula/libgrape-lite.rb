class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "aafc8e5e9b122c4bde4370ee3f2ab8afb043f2a1547cacc062991ad420e3b9a4"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ed50fa273a04b369892e2bcb127cb9104a7f24c699adffde0df014f0cbed7a6d"
    sha256 cellar: :any,                 arm64_big_sur:  "81ba4ead0d61e360b73d125f6ec426f539c412608731659aaf0f34a9a808fd45"
    sha256 cellar: :any,                 monterey:       "71c99960740542e6033ce9055d05107e8823b7632a78a0a8c0df7fdf7e08eab2"
    sha256 cellar: :any,                 big_sur:        "c3fee8aa45339ea0ebd06096d2cda7cdcbf81fb5dc3798e63696b56af43fe606"
    sha256 cellar: :any,                 catalina:       "531e59c654f3470fb9d01f576355e1da3cbf31ce33bc810244f606b88c733535"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96d9b222820202b5d107502a4ede041d20839a0c01befa93b1f5a306af54c2c6"
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
