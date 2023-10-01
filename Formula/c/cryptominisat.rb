class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.14.tar.gz"
  sha256 "c7c50083693abcc7da528baa16e328ac0f09b5a83092ebe38d426e918200d7f3"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "87ce32d47a15b3ea4234706f04f803dd13d811185497c6811c6dad70b134f116"
    sha256 cellar: :any,                 arm64_ventura:  "a5a95f3d7cea906853202955c4c4c9fcb84893f0be6fb15bf5e7859468245c7b"
    sha256 cellar: :any,                 arm64_monterey: "4fb9e91aa63923ffc2006e3a0e85c86bc71e78b6595404c300d3e1b4fdf68b31"
    sha256 cellar: :any,                 arm64_big_sur:  "4f859db8b42ca7439e1f3cad28bc55f67c4b12b4e309d54f66f1fd70e088a337"
    sha256 cellar: :any,                 sonoma:         "597218d0d5fe683eb7138e75ca7c8e69f347f44f7893ee4f9e9ef18fce1dc54b"
    sha256 cellar: :any,                 ventura:        "e3107d15e9c75b3e53361ce56343d8facb1b82714e18c638a133dc156150fc70"
    sha256 cellar: :any,                 monterey:       "17e2fc35d04c4e9091f0034224f9a53a3c13e8499739f862afb5091dddca3302"
    sha256 cellar: :any,                 big_sur:        "43629f3cee7a5035aeacfed05c0991dd3e5844ef8d6198c7c4527457138e9c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "021e712dd189684887b40b2e2f1f9cca3127ec02f1310ca1d5131f8ffd5f5b3e"
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
