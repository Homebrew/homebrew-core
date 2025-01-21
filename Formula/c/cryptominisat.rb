class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/5.11.21.tar.gz"
  sha256 "288fd53d801909af797c72023361a75af3229d1806dbc87a0fcda18f5e03763b"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sequoia: "48e71ad8b236eb736317e8b39f1a1fac2334e345b315aa9cd04bc843fe706580"
    sha256 cellar: :any,                 arm64_sonoma:  "bbeb9f9fe45dd2c144870ffa0a77c3b332c694cc7fa4e4c17cf219f4f3ab16c2"
    sha256 cellar: :any,                 arm64_ventura: "5ffbbf9b609d5a8e0e5dc2bce7237b0a6a7ed184bae66fa4a3a68c9f650b80c2"
    sha256 cellar: :any,                 sonoma:        "15d86b66627d95536445093c9702b5fcf439e6a6ad67037cc192b5bdec5f5e8b"
    sha256 cellar: :any,                 ventura:       "ed2723cfbf766a67cfea9a20aba7be51b4b05e0a6f723da3b1133e4260561828"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4291fd6c5691c5de3eeaadb1f6bee8dd83ec80e3ae9dd23baf2a48069b741ef8"
  end

  depends_on "cmake" => :build
  depends_on "python@3.13" => [:build, :test]

  uses_from_macos "zlib"

  def python3
    "python3.13"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    args = %W[-DNOM4RI=ON -DMIT=ON -DCMAKE_INSTALL_RPATH=#{rpath}]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args(build_isolation: true), "."
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

    (testpath/"test.py").write <<~PYTHON
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    PYTHON
    assert_equal "(None, True, False, True)\n", shell_output("#{python3} test.py")
  end
end
