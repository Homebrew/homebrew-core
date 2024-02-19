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
    sha256 cellar: :any,                 arm64_sonoma:   "bb7e79264dd32cf4ede2c7ab2b028598526879498f8bb711585153a39858891a"
    sha256 cellar: :any,                 arm64_ventura:  "e76cd1dd1b8f1ac3f4a0aaca595004fe811eb2fd0b7dfb540f0ee60d169a9d82"
    sha256 cellar: :any,                 arm64_monterey: "e093d179602de0af96280d852b1fabd5851da4dc490103b47ce36d2ec18cf2a8"
    sha256 cellar: :any,                 sonoma:         "bb280fb33d3a7bc5bfeb4ad89695fbed98032db10796dc15b6a9e44c3c4a29e2"
    sha256 cellar: :any,                 ventura:        "147d03b3922cbe238fa0a6370cd3baa045342aa42c016b09c231eb3b8d111e10"
    sha256 cellar: :any,                 monterey:       "4d69c369c2f570bab9e8b2b1e3f381608aae15611d1f44f715ac271abb19f3a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed67ac7f32718fef9dc000c2e926db165ab4d32d89996dcf18c63c2582652b56"
  end

  depends_on "cmake" => :build
  depends_on "python-setuptools" => :build
  depends_on "python-toml" => :build
  depends_on "python@3.12" => [:build, :test]
  depends_on "boost"

  def python3
    "python3.12"
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
