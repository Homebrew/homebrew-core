class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v2.2.0.tar.gz"
  sha256 "f7bc9c8f806fb0ad4d38cb6604a10d56ab159ca63aed6530c1f84ecaf40adc61"
  license "GPL-2.0-only"
  revision 2
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0496afacbeed5c3dd2639c6ef4fe6a5836f53acb24e9e490251038ef2e0eba59"
    sha256 cellar: :any,                 arm64_big_sur:  "8f7ae9dc594824f7f39479ff0fa1117d748bea995b591ca097da377371819d66"
    sha256 cellar: :any,                 monterey:       "577d1a789afc9150d95be1f7d985945475e101e7361bb9bc537e7a5f25397413"
    sha256 cellar: :any,                 big_sur:        "527c0eea466791699c4f117b69183ffc8dabd23af129b74d6666fad0f32d7a65"
    sha256 cellar: :any,                 catalina:       "6e6d02a3edbe7bf75fa19e7e0fd8c5027fbd66da12c7dadd7ffbb814714ded21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f8f5367be62ce0ccc3254f073b023e38f68515b8ab849d647865741bfa42f8a"
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
