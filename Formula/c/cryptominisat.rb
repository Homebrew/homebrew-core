class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.12.tar.gz"
  sha256 "d59bdaf06d71a14362535a58fcbe1ed53e5302de2aa64394253ccfae26db5b46"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f4de656aa865667cb8f6b7f18bd15fd9a0f3cf5525aec53507100268b7c083f7"
    sha256 cellar: :any,                 arm64_monterey: "b0528b2edba4932609be44ab1a026c217b3ac390082068ed1b4d935f47c2d98c"
    sha256 cellar: :any,                 arm64_big_sur:  "6b515e6e9a00c7f8dfbc8e37c95363f7d581eed113ed5451b49da2142309153b"
    sha256 cellar: :any,                 ventura:        "a31ba29eb5e0c24b4bd86a23e32aedd39b3853487e004e2f0fb0b8e7d647d063"
    sha256 cellar: :any,                 monterey:       "3bf4fd1ef6dea8e670adc3fa486a72d06f05e8f64e48f005d4dd6b5ba4597454"
    sha256 cellar: :any,                 big_sur:        "d3fcf58b537413d0c675ed90fa79f13419faacd7d306c9b7b6c654ea372ef272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f52e7b7a4b7faa91ea27b84da64a6a66a1e1d8eb0d16ff1a277228f445e676de"
  end

  depends_on "cmake" => :build
  depends_on "python-toml" => :build
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

    system python3, "-m", "pip", "install", *std_pip_args, "."
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
