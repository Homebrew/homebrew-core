class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "384f25cd543ded1ac99fe8238db97a5d90d24e1bf83ca8085f494acdd12ed86c"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b0b37cab12958e277e30b3a5a7c02ecfef33e3b6d99c962503776b049f436d63"
    sha256 cellar: :any,                 arm64_sonoma:  "db8dc89b1424e97e6f82b09c0b8fd51c5ae9f2e8a12bfac8f77c59b80524b687"
    sha256 cellar: :any,                 arm64_ventura: "8a97f12d5020decbb6af615cef1b06f095cf61050ee1da2d07640c4463ed98a4"
    sha256 cellar: :any,                 sonoma:        "6e3428ea16b46226e1cb905ca2626720e33826779c6de5083508113d208a7f25"
    sha256 cellar: :any,                 ventura:       "6d0ad2d5d76f50ae49277b54a30b933ad6f9978dcbcfa9bd0dfccd1607245669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74a4fe1f03be0984b0a8858af603e3edf6b3c41a5671413aa3774727024a6973"
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
      -DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3
      -DALPS_BUILD_SHARED=ON
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
    (testpath/"test.cpp").write <<~EOS
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
    EOS

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      set(CMAKE_CXX_STANDARD 11)
      find_package(HDF5 REQUIRED)
      find_package(ALPSCore REQUIRED mc accumulators params)
      add_executable(test test.cpp)
      target_link_libraries(test ${ALPSCore_LIBRARIES})
    EOS

    system "cmake", "."
    system "cmake", "--build", "."
    assert_equal "3 #2\n1 (type: double) (name='myparam')\n", shell_output("./test")
  end
end
