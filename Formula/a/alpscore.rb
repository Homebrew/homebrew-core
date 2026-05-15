class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/refs/tags/v2.3.3.tar.gz"
  sha256 "2ed251001fbf1889aef8cf01ee80f87e95e25edb3d6b561d053ec4ddbd27d6b2"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "16b003e1fcfc63f47e2217207533f1405444f36f6b369ffb3b6a87797d2299cc"
    sha256 cellar: :any,                 arm64_sequoia: "d508dd93dcb9b30108f016c3bde1e489a068ffd973c4ec1b8d9533a8a46404ca"
    sha256 cellar: :any,                 arm64_sonoma:  "19cf64b22d44d1ccdfe0191d7bfb4cc3612099a6dc4dd3d097c289ddba5265c9"
    sha256 cellar: :any,                 sonoma:        "4eebc3f7b25ef31e92e780d7f2d1ecbb9042ede6babf538a26b69605492439bc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "05f2a3395aa08f324c86a989a576c4befecee594adf30429b8b43c541002c81a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e27347e7bd388ee1d21bdde50c1d0311141caabcbd7e9900fe8cca5fa09a7ef2"
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
