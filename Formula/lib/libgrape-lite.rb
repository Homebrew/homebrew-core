class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.4.tar.gz"
  sha256 "4d7c08560d56fde4a407566fea5ea348cf8ea7df5dbcc3285dcbfe6d9e5d6ff7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "a9b43421f7640ae0bf58c960c15c1f6ef7ea8dbffd6114085f51cf1ec786da4b"
    sha256 cellar: :any,                 arm64_sonoma:   "169a84d962028247357fb70d3fd9a00eef09d04043bfc599c547b29545204dc6"
    sha256 cellar: :any,                 arm64_ventura:  "fb65f947aab53a0b99aecdfe1eb27d7b3ebd3bf2deaae44983106d79be23324a"
    sha256 cellar: :any,                 arm64_monterey: "669d5c4c46c62ca376f7d88d6ccd8ca1af65e4c5c496c22d59239dcc64aa7bb7"
    sha256 cellar: :any,                 arm64_big_sur:  "e39c3c95ebf47c8a91ad1f4ec55e150f0fb983a0749b1c918fabb67cb7782b59"
    sha256 cellar: :any,                 sonoma:         "2d3b960d3911a6a179bee03366ac528a70409ebda55a15fafbc2fd39e173030a"
    sha256 cellar: :any,                 ventura:        "56fc6ce45234cdeebabf4e0e533cdf410fcb67f118635b030a774b5c1d80435f"
    sha256 cellar: :any,                 monterey:       "5df9681434c5b8db7a4f10bc80d34154362a6e14eb8659166b857c04b11f188c"
    sha256 cellar: :any,                 big_sur:        "dca697a6f0ffe5241d9e87cc361e3155351524e8087b105ceb383002a3abf364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4daa1bec1b6d6e493964783687cc05609cfa2e6e97279450134de32672eae244"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "glog"
  depends_on "open-mpi"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
