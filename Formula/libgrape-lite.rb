class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "072c8e2815f1f6c2dce31df5ee32926bc7c287e305a1c371be16b3a9cd7ee776"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "fa68d928ae57e36e1ad11f32ceb947da047ff4f25028c299f8cde64da2eeeafc"
    sha256 cellar: :any,                 arm64_monterey: "5f060a4a642af2b293ef35fc2712df5752b9f73cb69006759c19a84aa795aeca"
    sha256 cellar: :any,                 arm64_big_sur:  "95c722e157a579cb2c463c5078f52c93865fad6234de79324b00225cc8ea5b4f"
    sha256 cellar: :any,                 ventura:        "5695acb3d894214ef271d4894d39374c20e14070759092dda8a3d37c3eea6477"
    sha256 cellar: :any,                 monterey:       "1a419a8c83c0119cc8b29a30007b946df5dbc7bb4ced8c5725de481243dd8100"
    sha256 cellar: :any,                 big_sur:        "70023bb2232333378cd635192bde6814e1cac5ed880740de77f3c6a482712199"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee2074a31f14ab902b08f3f824cc892a56e9a047f1cdf70d471e0379ac4b833b"
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
