class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "bfc8c42fc372a894a3e120afe2c7432f8e79b55730dba43eee42e222615fefc1"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "40dc2149a084c00f49ffb90537d54bb25928f9ec40de4a742ede77e7c59e1874"
    sha256 cellar: :any,                 arm64_sequoia: "602d64d3104a5e5127b1f488a0619c5210d0a71aaba6083222db9d0436b36731"
    sha256 cellar: :any,                 arm64_sonoma:  "f2116085eb34048843f3c6aca11951cb4c7cade9b257f6c22e400f5aa67ec363"
    sha256 cellar: :any,                 sonoma:        "df4cfbe5b40dfde376fba083e33bc1323b73914c8c2b0455471851b37e0ff42c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b376b567d1dc67245a03884a984d8a6ed3fa483f27cc954ab625d0d220aa2b39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e07129f9f6f769198cac871aae40e7e57356c10a98b0bcc50abc476b70448998"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "boost" => :no_linkage
  depends_on "eigen" => :no_linkage
  depends_on "hdf5"
  depends_on "open-mpi"

  def install
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
