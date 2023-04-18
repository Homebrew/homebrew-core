class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v2.2.0.tar.gz"
  sha256 "f7bc9c8f806fb0ad4d38cb6604a10d56ab159ca63aed6530c1f84ecaf40adc61"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "391ce80c683398d28212dc92646e445cd2c4f5c855e87dc1b5139ab120d8d052"
    sha256 cellar: :any,                 arm64_monterey: "7871e3e67a75c290db8e660f2bc1ec61429e9d2729a93dec35ff3dd388e8cde2"
    sha256 cellar: :any,                 arm64_big_sur:  "cd40f73fe61378e84131abe4a98493a0e8eab7b92b4c8840344637e5b706a43c"
    sha256 cellar: :any,                 ventura:        "e2a24a3dabff3231a2b8a7bbbb6c97a01fb75e5e5a2c5d992261e466cbecfdf9"
    sha256 cellar: :any,                 monterey:       "f657811bc26f0813bdfa09d879ab4b28066f01f809703bcea01c99173ccb4090"
    sha256 cellar: :any,                 big_sur:        "48dfc02950aee1ad3e491669f8594c240d6010be24e3ee2da18a769838fd84eb"
    sha256 cellar: :any,                 catalina:       "fcc8af526ea82cb34aedc72462583e600cf1e7b1c5c8d48811b514de8556783e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4249c8eca7818304c1c460c69becdbe3a2f3b34446dd9fb93ada171169f189f"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "hdf5"
  depends_on "open-mpi"

  on_macos do
    depends_on "libaec"
  end

  def install
    args = std_cmake_args
    args << "-DEIGEN3_INCLUDE_DIR=#{Formula["eigen"].opt_include}/eigen3"
    args << "-DALPS_BUILD_SHARED=ON"
    args << "-DENABLE_MPI=ON"
    args << "-DTesting=OFF"

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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

    args = %W[
      -std=c++11
      -I#{include} -I#{Formula["boost"].opt_include}
      -L#{lib} -L#{Formula["boost"].opt_lib}
      -lalps-accumulators -lalps-hdf5 -lalps-utilities -lalps-params
      -lboost_filesystem-mt -lboost_system-mt -lboost_program_options-mt
    ]
    system ENV.cxx, "test.cpp", *args, "-o", "test"
    assert_equal "3 #2\n1 (type: double) (name='myparam')\n", shell_output("./test")
  end
end
