class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "77b7f08ad10b26ec7e6f60bf90ab8281208758702a9e8d9dd00b1cd6f5560f39"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "21f21e45a638e2ea14cc1f9fc4914fec4bf1526dc6d1a12b4c966c16cc4b2d2f"
    sha256 cellar: :any,                 arm64_sequoia: "a0f27854c66b84ff7b9457c056464ed04cd44f6bbcbbe2c194589a10906a9ff5"
    sha256 cellar: :any,                 arm64_sonoma:  "4ed7d1abaeff94d789b82eb98be06f932fe14fd2a226c1b9b9070fb9e859bf3a"
    sha256 cellar: :any,                 arm64_ventura: "3cb22292371844f5c1be714382a0fdb9b6053933864dafc60302dddfc6dd0c12"
    sha256 cellar: :any,                 sonoma:        "04f1753ca0ee70b8b79015d789b0d926587ebffb00f24d0e3778339975ebcf1d"
    sha256 cellar: :any,                 ventura:       "8f069e6f8225035353609b883fe9094b257976fdc7f50f89a10655ac63f2231f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e6204269477e655d73a80f39817e5532f96784bd803db190f9c1c346cee67b19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1cba36dc3c38c447be22ad24fbcca0b1da56cfa6c409d14247244f95e30c6684"
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
