class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "75b3b27dd6ac5b9996acfe0a349fdb1282d3cfdcfafd17cc25091969318b268b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73b367d40baaa56d4a44b0f0424b10f881bf49060d11940eb3ab6f0add951091"
    sha256 cellar: :any,                 arm64_monterey: "327f35d2cec425aec2f1751900891c88ee1ec2fd68bc0045efa5ac3d252782dd"
    sha256 cellar: :any,                 arm64_big_sur:  "249c5b0c9059bf8d997f261cd57f7341ad2b071d2e69a277e6a4c3ce5bddcf50"
    sha256 cellar: :any,                 ventura:        "0af8b144817807a9dd45e5db78f07112b72f264ffc40cca7c3a638bff93b1585"
    sha256 cellar: :any,                 monterey:       "7ce501104e6a79e55a3a277c0a9fb0f8a9b756391cddece2a5e4cd7efc4a2147"
    sha256 cellar: :any,                 big_sur:        "08bdd38a3bce60ed089145a91e5ea7f96bfb3ba6e49fee95966b8584dd95f971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa0b442921e7c2fd89a119c8bbf89c8c2578448bc04ff7354b146efcce92f51d"
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
