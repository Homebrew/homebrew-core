class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "fa3b0a67d82894d2766fe8c9081d8db18b92906754ad1073846185fbaf115634"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "a70f1ef4da2f4efb5d1f3094bfa375778d04e4289bc64acd330aa39575129d8c"
    sha256 cellar: :any, arm64_monterey: "2cebfdaa343bc9e675800237a5b8411e337c6ec5418be172f9d4ea6bf2fea88c"
    sha256 cellar: :any, arm64_big_sur:  "d8bb1719e11f727dc469297a2d490bad773306f1dab4af48027fa70ee4b86c73"
    sha256 cellar: :any, ventura:        "3684375648cc7b45edfa7f423d40d7dfa9ad90949d2080e10ff7ea7ff8782c09"
    sha256 cellar: :any, monterey:       "6142b05b91f906c5350e29987635541f0f3d95ead8cef9b2275218c3831112b3"
    sha256 cellar: :any, big_sur:        "da447dc99ac2fd7015f29577649828acda4638043ac426a79878b3d09f88e240"
    sha256               x86_64_linux:   "3b48dbca3907f72453e399a137edbff08911cb914a306d30391dbdad3bc6905c"
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
