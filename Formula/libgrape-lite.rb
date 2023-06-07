class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "b251f7c0614d74d4c311b9821015dd722e2eb8c7b2d80bf0cf17183a60e4dd85"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "f635e967f309c70c230dbc048b4bb667fafe6715b86a0803be3469c082e92089"
    sha256 cellar: :any, arm64_monterey: "fe8474892fec74e5f4ceb1161805ec1a4363cfb5b1775b086f6be478e4f727ea"
    sha256 cellar: :any, arm64_big_sur:  "1d732141e7f7b42515da6a88df00843a7679981067280a8eefd158596b33200e"
    sha256 cellar: :any, ventura:        "488fa95b36d456f88bbc9df870c25c41b89b6c27f72b96fcef7d12468007566e"
    sha256 cellar: :any, monterey:       "06a908aa0baeec78620dd62f08acaba18d7efa92d06d961f25ea4727a1c4f480"
    sha256 cellar: :any, big_sur:        "ec5ddd15b19eab02c17c5e0336022b6bd2481e071e22eeab58552b70bee82f5e"
    sha256               x86_64_linux:   "a85ff55fb72584cf51a7f7982008e23ed96d0328093740360056c577650d2d92"
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
