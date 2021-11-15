class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.8.0.tar.gz"
  sha256 "50153025c8503ef32f32fff847ee24871bb0fc1f0b13e17fe01aa762923f6d94"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/msoos/cryptominisat.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "cbfd9b642da561b05f4b73677892b9175b87af7c1bd43542f9326b164bfe330f"
    sha256                               arm64_big_sur:  "8b9940bdf5011a8f060de82576726b7138a60975f56fcd7113b692e026444021"
    sha256 cellar: :any,                 monterey:       "0f9ea0f5cc7850fcba9c5f72a13dcd03bad10f1b200d57c70aebde2c9aa9b67e"
    sha256                               big_sur:        "ca952863f4a030cff0f60b3dc1b598c9a070460b5372577e63c8df577008e5eb"
    sha256                               catalina:       "9314367f35d7d82790d4840b04d744fba37196f068fa38b899c7ac4c7e8f987b"
    sha256                               mojave:         "2ad7c47169eae4780e42ddec65f1f6144fc59ee5585dd8d26ff5d270d25d9cc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add4bd75d5ec2f5a1ce559282d81e207e99cd6da2b90234a2971808e3e8a222b"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "python@3.9"

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DNOM4RI=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    (testpath/"simple.cnf").write <<~EOS
      p cnf 3 4
      1 0
      -2 0
      -3 0
      -1 2 3 0
    EOS
    result = shell_output("#{bin}/cryptominisat5 simple.cnf", 20)
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~EOS
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    EOS
    assert_equal "(None, True, False, True)\n", shell_output("#{Formula["python@3.9"].opt_bin}/python3 test.py")
  end
end
