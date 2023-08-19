class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "e0701a389f615eb169faf0272ad4aa0679b8e7b06f94a4732c8232d2f40fc0ae"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5437b82e7cbc55ec1394e21b8cecb11c7d5149b9205afdaee7765bded95e0d5c"
    sha256 cellar: :any,                 arm64_monterey: "9ca019ceb41ef6b447df677376bf396c8fcb49b1bd75a4c69994492c1487e0fa"
    sha256 cellar: :any,                 arm64_big_sur:  "7eead4cc06b4f89b45cd365e98577e6f13985569f7781484d3b3a759969df6d5"
    sha256 cellar: :any,                 ventura:        "73510a5810bf7c2c54af3f8b1188051e4651739d584a0b03136d4e80ee84a869"
    sha256 cellar: :any,                 monterey:       "078f61025dd058c4e0fcd83449142abfa1c624459878bd15c6a8c2f8cec08313"
    sha256 cellar: :any,                 big_sur:        "a83c2f7d28fd6efc4846641070514f0fe13e1e6af4320dcc247c343323e304a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d6a99920810c692f8420e82009a38c7ec32b316e38bb1a38e42a85f033a27a3a"
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
