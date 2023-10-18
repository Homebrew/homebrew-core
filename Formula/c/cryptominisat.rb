class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.15.tar.gz"
  sha256 "b2ee17e7a5c6e6843420230215b6c70923b6955f3bef1e443c40555fc59510b0"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "755e585bff7af7ae6f457996beb0ddeabb6a52bcae46c52e5e247323fcb7a739"
    sha256 cellar: :any,                 arm64_ventura:  "b240712ecd356bdcce37813db950f31f7c1f8759db0892630a7044035e6718f8"
    sha256 cellar: :any,                 arm64_monterey: "20bf0b7e0c95aa705dfe6e32b060a6c35aff1a86e779e767773c6596b4ab5968"
    sha256 cellar: :any,                 sonoma:         "79e734199d02d42f6f19d24ff6bcc7031b6c140c0d91a4948f413620adfe1e46"
    sha256 cellar: :any,                 ventura:        "6dadb20d4f39808d6d95ebf75ebdf547e1c66c42d3fd8e5fd86a8be52a718093"
    sha256 cellar: :any,                 monterey:       "37121a4d8cfad6bfc3e8a370c7d0d438ad93b7dcf73e9bdc23e0dfe2c6ba53e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c9c7038156389d5cf9541e957f4f9042b664845d5310d73a6c3789a3dd195f1"
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
