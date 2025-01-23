class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "384f25cd543ded1ac99fe8238db97a5d90d24e1bf83ca8085f494acdd12ed86c"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "4a5c92030e5c1a446db1062b1007ffc8d1314cd77efdf5f9194ac8347b5cdbe4"
    sha256 cellar: :any,                 arm64_sonoma:  "241dd3c647a0d5191a7e50d97f57cdfafd10cad5d1cbb8fac7b9f3065587fa09"
    sha256 cellar: :any,                 arm64_ventura: "9290875a72e7c89cef6888519d3ea0c0f3ae95fb08c6d0cef0e4f07443cb7693"
    sha256 cellar: :any,                 sonoma:        "87f9dbe716b04a95d46c7d850b9778a21abf5dec122d58de265b65420c494437"
    sha256 cellar: :any,                 ventura:       "8a7ca50ba1331ad8a116d7c3189dfe258bec8f476963659c767292680406efc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e6592d3e7563ea45cd9fd053c1b1341c1f7e0b784616fd887b680ecb7fefa494"
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
