class Alpscore < Formula
  desc "Applications and libraries for physics simulations"
  homepage "https://alpscore.org"
  url "https://github.com/ALPSCore/ALPSCore/archive/v2.2.0.tar.gz"
  sha256 "f7bc9c8f806fb0ad4d38cb6604a10d56ab159ca63aed6530c1f84ecaf40adc61"
  license "GPL-2.0-only"
  head "https://github.com/ALPSCore/ALPSCore.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "60542a579fdbcfd7e115a21906681ef53ba08541a6811d9adf3ce1de11390f88"
    sha256 cellar: :any,                 arm64_big_sur:  "3fb8eeebac63feda029c063b3a74de6c9998e97b88431618b8b724c55f743b10"
    sha256 cellar: :any,                 monterey:       "c84c178fa07cd5d9aad47530baae782ec008945486fb52551385668f4ec27ca8"
    sha256 cellar: :any,                 big_sur:        "578b46e4adf6a968c29f6e33b30ccdfb1552d9a209a5acc1410bd755b47a80b0"
    sha256 cellar: :any,                 catalina:       "eacb1c74617905918455e0b6bb4cbcd2b8404582ab360d6e4c3e7fd02bcb920e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae800598e03dde4b7e42035be7fc8b2858276ea5ef02d207882dd3f13d85c1c8"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "hdf5"
  depends_on "open-mpi"

  on_macos do
    depends_on "szip"
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
