class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "77b7f08ad10b26ec7e6f60bf90ab8281208758702a9e8d9dd00b1cd6f5560f39"
  license "Apache-2.0"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "79620dba15f36c38dd544c62bd645012660bb95528b9a45f6f579f7e34f6428b"
    sha256 cellar: :any,                 arm64_sequoia: "ebf7104e35af1ba8f82578d2706be2da6e277423818d5f0b313cd36d38a464bb"
    sha256 cellar: :any,                 arm64_sonoma:  "cd15174a51539d335e79290b4cee01c725cd66b092870f0930c524ce3e3d6dca"
    sha256 cellar: :any,                 sonoma:        "329913ab9e2384df61b0bd4a4c4e67967cfc844fc738b8553fc6adbd8607cef2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "365b7d9bc18ce658df4d10ff69d18543b3b0a18f8100b304afeb71874c657025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8fe5448439c287b66ca142385aa71dc91bbc24f6efdde70be5c2b8e3084178c0"
  end

  depends_on "cmake" => :build
  depends_on "gflags"
  depends_on "glog"
  depends_on "open-mpi"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~CPP
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
    CPP

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
