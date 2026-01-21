class LibgrapeLite < Formula
  desc "C++ library for parallel graph processing"
  homepage "https://github.com/alibaba/libgrape-lite"
  url "https://github.com/alibaba/libgrape-lite/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "77b7f08ad10b26ec7e6f60bf90ab8281208758702a9e8d9dd00b1cd6f5560f39"
  license "Apache-2.0"
  revision 2

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "627453323fe0db452b85a864ca0173ee52fe9dbd8a5a34741c02afd885caf611"
    sha256 cellar: :any,                 arm64_sequoia: "917d4cb3fd061144c28cd909922f6da05fdde433eba392b1686f4eb31b4d9b06"
    sha256 cellar: :any,                 arm64_sonoma:  "48cf053978bdf705c4ea11eeaf8935a250ff53d46d04f67af71594de8e150a07"
    sha256 cellar: :any,                 sonoma:        "6f2280e3c1b484230d53a631b45c2085379f5e1519e89a937b4b22041421f5bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f3c3bf46a28ebda8692ad43bde5af326cd2a93c28ad5e5ebf71bc8b24b1e0fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "958b7eb7dc114040a3275bc9be6c668c5529a31705810d330cfcab8f46ee3f18"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "gflags"
  depends_on "glog"
  depends_on "open-mpi"

  # Apply open PR to build with glog >= 0.7.
  # PR ref: https://github.com/alibaba/libgrape-lite/pull/181
  patch do
    url "https://github.com/alibaba/libgrape-lite/commit/8093d80574c30c041ecd867ab4a8d74328905b8b.patch?full_index=1"
    sha256 "f31b1c59a2b20f83d254f454d565b6a8c8ea27a024f78efff169563af5c40938"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 4.0)
      project(test LANGUAGES CXX)
      find_package(libgrapelite REQUIRED)
      add_executable(test test.cc)
      target_link_libraries(test grape-lite)
    CMAKE

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

    system "cmake", "-S", ".", "-B", "."
    system "cmake", "--build", "."
    assert_equal("current worker id: 0\n", shell_output("./test"))
  end
end
