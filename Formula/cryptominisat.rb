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
    sha256 cellar: :any,                 arm64_monterey: "a37911641a25c49ef4a4152531c93679f4c42694688d7695e84b31fd0f56df4a"
    sha256 cellar: :any,                 arm64_big_sur:  "c30ac0d1f97c3138a1d75c8519718c38d9481237ef891a4aa9991de796db2927"
    sha256 cellar: :any,                 monterey:       "8432fed87a785122585fcbee69a3256fcb9c537cbd6d6a404d63226a5b15262e"
    sha256 cellar: :any,                 big_sur:        "c4ff5942f8bfccf27d37065f8b010b72fca214641f20530ae4b95831e48d1826"
    sha256 cellar: :any,                 catalina:       "ef55bbbfe712fe39128d4abbd1cf023a2b496b1e92029de0ea32ce5fb13914a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b469605be2c28104303217c39f752079c51e887b245c306ff831ccb9051a62f"
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
