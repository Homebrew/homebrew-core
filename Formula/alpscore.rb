class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v2.2.0.tar.gz"
  sha256 "f7bc9c8f806fb0ad4d38cb6604a10d56ab159ca63aed6530c1f84ecaf40adc61"
  license "GPL-2.0-only"
  revision 3
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "88c6e64b6e8ca7f7354ec0b65c281c82d9fd7f7efe35966411fc3151ec539b3c"
    sha256 cellar: :any,                 arm64_monterey: "9e4266bcf31a8c7af05d8f582d23c773ab814ba033251bb221000b0de00c4b90"
    sha256 cellar: :any,                 arm64_big_sur:  "d05d9821803c3f2db25b613b77ed4e271c25f7cd8696b39bf474ea477eff4aa1"
    sha256 cellar: :any,                 ventura:        "f1645afda2a5b5d554c12f8156dd84ab32ef21a0aa112463a82a3694e2b0ca95"
    sha256 cellar: :any,                 monterey:       "1b80a39cdcb57578928c6a4fc88218160236e947299b281acfc12f8678f3061d"
    sha256 cellar: :any,                 big_sur:        "311a9f813a4e9f6147de06a0975c6c18eaec990ece62326de19e53ff40dbb435"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad3a9b4d34851a8b32ccde1aff2ff675de151e5af7a06dc831284be0c3fe2f6"
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
