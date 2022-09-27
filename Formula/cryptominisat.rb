class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.2.tar.gz"
  sha256 "c9116668e472444408950d09d393f6178d059e4b4273bb085ba9b93c297c02a1"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "967e81c4de469fcca8cdd17e243083bb7226109a803fb90aa596bf6e9cd212b8"
    sha256 cellar: :any,                 arm64_big_sur:  "bfcf82cac8669f69facbae7042b80467c01564b674c57941fde79f52f5e5fb2d"
    sha256 cellar: :any,                 monterey:       "7e945a25fe6701eb5431b6ce6e0535dda6850aaad9a7b87106aab64b529302c1"
    sha256 cellar: :any,                 big_sur:        "023747bdc60af30e7287a74762800b3051a7ffeab14dff1189c4a64c470f9455"
    sha256 cellar: :any,                 catalina:       "abd2c00cf458f891ff1dd006ad928e198712bb58113a852c487741d22781f1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f17416cfc5100bc03e00d233d9b9c77bf803aa83ae8c203e3c44182fe094dfdc"
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
