class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.6.8.tar.gz"
  sha256 "38add382c2257b702bdd4f1edf73544f29efc6e050516b6cacd2d81e35744b55"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 2

  livecheck do
    url "https://github.com/msoos/cryptominisat.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 "e61f326193f4c4e406b1db82fdb6afed10ffe628c16ef62774d9c5fa46c3546e" => :catalina
    sha256 "28fe0cccfd99cdfa95261abf62884b63bd961a814c8fc751981f661838fd6cde" => :mojave
    sha256 "59e248820e0822ebdeeb1ab1fab6ca8c1382428420375ec2edc024ed5edd8eec" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on arch: :x86_64
  depends_on "boost"
  depends_on "python@3.9"

  def install
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
