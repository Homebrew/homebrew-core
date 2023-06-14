class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.4.tar.gz"
  sha256 "abeecb29a73e8566ae6e9afd229ec991d95b138985565b2378af95ef1ce1d317"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3e762fc5a4d34e358a0abec31558a1aab5651632b3852f86d9545bf8ae3c704c"
    sha256 cellar: :any,                 arm64_monterey: "8ffedf88208e509f3832ce06711251cb6caf2c27077764a6180f23595d78d17d"
    sha256 cellar: :any,                 arm64_big_sur:  "0a763bb8c43d659b7c759e2c0541034de578db868d596061769a7c77f19d8aa5"
    sha256 cellar: :any,                 ventura:        "223b6fcf79841ed9df9d89e27719e0fdbd4a385fe5ba65296aa10ed0b4cb45ea"
    sha256 cellar: :any,                 monterey:       "19df0c2c95d31d90c7fe2ca014497521128e1b767d7ec0ea99e4622107385e4f"
    sha256 cellar: :any,                 big_sur:        "6906877f5c64fc3a93d5a0a52e07b1c7b1a17c0d07d2fff71eb341b401ef78ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aefdbafc5a3e4c71964f6750ff6911503c98bc671176d0d8130ce5396036111e"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => [:build, :test]
  depends_on "boost"

  def python3
    "python3.11"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[-DNOM4RI=ON -DMIT=ON -DCMAKE_INSTALL_RPATH=#{rpath}]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, *Language::Python.setup_install_args(prefix, python3)
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
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end
