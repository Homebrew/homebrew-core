class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.4.tar.gz"
  sha256 "abeecb29a73e8566ae6e9afd229ec991d95b138985565b2378af95ef1ce1d317"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ebe5f3d813bd94d6366080733cd6a8b61ae2dc1bf243ee57dca8678b551d7bd6"
    sha256 cellar: :any,                 arm64_monterey: "caf7fa1899076b2d98333f253505d802ec14b834f9915fdfbea51a4d525444e3"
    sha256 cellar: :any,                 arm64_big_sur:  "31f3b36598745c142f428451dde74430228e23c737222de2b5e743ab8f163d44"
    sha256 cellar: :any,                 ventura:        "1f223253304a9c846df31077bce73ed3451c000f96acefcd3a51cf52840c9ed9"
    sha256 cellar: :any,                 monterey:       "a790c4ddfe4eeda555979d5a89e05ac976881287698613aa8b966a108503533e"
    sha256 cellar: :any,                 big_sur:        "1ed4e6fef5258653335a460ef1d8aa9c6d4c8fd03b507ac7dc9ce8b985a9d53c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbbfec94567e6c6a80f7670eae3b4838d8a90d955a92f58325fcece79212dac9"
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
