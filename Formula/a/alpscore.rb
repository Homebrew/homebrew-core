class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/refs/tags/v2.3.2.tar.gz"
  sha256 "bd9b5af0a33acc825ffedfaa0bf794a420ab2b9b50f6a4e634ecbde43ae9cc24"
  license "GPL-2.0-only"
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d32af432da55d533b24bd30a60f8e2845ae2bfe97a3b00d5f53e0d58282eeafe"
    sha256 cellar: :any,                 arm64_sonoma:  "d8e1ec2c2f445c059c8a6097f6900c4b3366b61f17bb4e985a047dfc71545cb5"
    sha256 cellar: :any,                 arm64_ventura: "7c51b1fafed3d6683f0a7711239ae8dfb960a3f9242e98d04889397112a0bbed"
    sha256 cellar: :any,                 sonoma:        "ded6b4a5102bf72ee89b709f48c7363e592435dbf8cab002ec173c7d392ccf47"
    sha256 cellar: :any,                 ventura:       "5bb961582c752e10a6d731ccbd7d546c1c2d4193af2c0f5cc1254e193d4568b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "99b0e57c0f9b7695869872b039c3d3723a86f4cf85a25eb44cbca47830a90d21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "992bb58ad888c4accb8a6758f3ec2b4b378af7523626efa5d6785de54c32bf3b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "hdf5"
  depends_on "open-mpi"

  def install
    # Work around different behavior in CMake-built HDF5
    inreplace "common/cmake/ALPSCommonModuleDefinitions.cmake" do |s|
      s.sub! "set(HDF5_NO_FIND_PACKAGE_CONFIG_FILE TRUE)", ""
      s.sub! "find_package (HDF5 1.10.2 ", "find_package (HDF5 "
    end

    args = %W[
      -DALPS_BUILD_SHARED=ON
      -DALPS_CXX_STD=c++14
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
      -DENABLE_MPI=ON
      -DTesting=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Fix Cellar references
    files_with_cellar_references = [
      share/"alps-utilities/alps-utilities.cmake",
      share/"alps-alea/alps-alea.cmake",
      share/"alps-gf/alps-gf.cmake",
      share/"alps-accumulators/alps-accumulators.cmake",
      share/"alps-mc/alps-mc.cmake",
      share/"alps-params/alps-params.cmake",
      share/"alps-hdf5/alps-hdf5.cmake",
    ]

    inreplace files_with_cellar_references do |s|
      s.gsub!(Formula["open-mpi"].prefix.realpath, Formula["open-mpi"].opt_prefix)
      s.gsub!(Formula["hdf5"].prefix.realpath, Formula["hdf5"].opt_prefix, audit_result: false)
    end
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <alps/mc/api.hpp>
      #include <alps/mc/mcbase.hpp>
      #include <alps/accumulators.hpp>
      #include <alps/params.hpp>
      using namespace std;
      int main()
      {
        alps::accumulators::accumulator_set set;
        set << alps::accumulators::MeanAccumulator<double>("a");
        set["a"] << 2.9 << 3.1;
        alps::params p;
        p["myparam"] = 1.0;
        cout << set["a"] << endl << p["myparam"] << endl;
      }
    CPP

    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.10)
      project(test)
      set(CMAKE_CXX_STANDARD 14)
      set(ALPS_FORCE_NO_COMPILER_CHECK TRUE)
      find_package(HDF5 REQUIRED)
      find_package(ALPSCore REQUIRED mc accumulators params)
      add_executable(test test.cpp)
      target_link_libraries(test ${ALPSCore_LIBRARIES})
    CMAKE

    system "cmake", "."
    system "cmake", "--build", "."
    assert_equal "3 #2\n1 (type: double) (name='myparam')\n", shell_output("./test")
  end
end
