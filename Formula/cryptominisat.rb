class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.4.tar.gz"
  sha256 "abeecb29a73e8566ae6e9afd229ec991d95b138985565b2378af95ef1ce1d317"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "55c45ccdfd3047c85937dbe13666b013c8495bd7b2abcb67c2fdb0c5106200f9"
    sha256 cellar: :any,                 arm64_big_sur:  "dd93c87900b8f490d735d691e20f17f0f6dfadaf0dc1fdfb4a04d459de047e4d"
    sha256 cellar: :any,                 monterey:       "e014ba19bfa3e86220fd6ce2c08a90a7a182685986eca762c1f6e317f19fe13d"
    sha256 cellar: :any,                 big_sur:        "5847aace0165707d81335cf262648c806eeb27f168e3ab27a2dae6e4c2aebf95"
    sha256 cellar: :any,                 catalina:       "d27a51f89337e37222c3bb5bd6239c1411a5aec1531904832a11ab378742a266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c26d59f2db3e9b46d1a78594c4c704443dadff284308ae22aadcaa7d2b776341"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "boost"

  def python3
    "python3.10"
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
