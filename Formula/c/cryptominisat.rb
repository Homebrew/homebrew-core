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
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "375e4707e22ee3af289feae7511a59f82a9ba27d94224c11019232432c549c01"
    sha256 cellar: :any,                 arm64_sonoma:   "2c8c6da7ff393d94511e7269bb60eecc62cf127d917ac277398d7e5cd68e6e62"
    sha256 cellar: :any,                 arm64_ventura:  "c2de3aa4b6473c9dc6203f411063688450605fe3ddb41c7f066b8b6fce6be8ea"
    sha256 cellar: :any,                 arm64_monterey: "14634ab5db2855aeb65c872845adf42008b7c765f1f79d82cda4697ab933f6ed"
    sha256 cellar: :any,                 sonoma:         "fe7e08322d2e88281fc034aaa0bf966fef9ee2111eaec3322193bd7536c5faad"
    sha256 cellar: :any,                 ventura:        "5a703dc7a1902709526bbb7371f922b3aabde24fe6e2369a32e683732c1f49ff"
    sha256 cellar: :any,                 monterey:       "b3b62352b32d3b09d9a5b6551f0ab768a2473448dfe6470b8145a61b0242953f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15728a5d49b213f34985aed6590d9ea3a25cdebc9701b139734f7a6e0cf0db45"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => [:build, :test]

  uses_from_macos "zlib"

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
