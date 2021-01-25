class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.8.0.tar.gz"
  sha256 "50153025c8503ef32f32fff847ee24871bb0fc1f0b13e17fe01aa762923f6d94"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url "https://github.com/msoos/cryptominisat.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "a44fd7c5ef4e744e5f2b09fb9ed007b08c5a3a77ce77f82a84c7c50a1fc3741a" => :big_sur
    sha256 "2c6b3e384755e1696497a521e474a3260e4bfbd270a5008b0d4e967e3fa263dc" => :catalina
    sha256 "8643301b4c05958d3c220f1c4f0a155ba2ae9877871598c9862b7479a1805e08" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "python@3.9"

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", "/usr/bin/clang++"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DNOM4RI=ON"
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
    assert_match /s UNSATISFIABLE/, result

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
