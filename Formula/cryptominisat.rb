class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.7.1.tar.gz"
  sha256 "d09f118a3d4392e3352a6285f600a5897e301b186a764404a37a911f4d91528e"

  bottle do
    sha256 "6de78ffbfa1ae394f9e0ce868ae7a49412014d63fcaccb22dfefc8909564a18b" => :catalina
    sha256 "f1120dbb776e906bfc0773dd4088df95cbc845d5ca5d26d375dfba9187c00656" => :mojave
    sha256 "5aae642269d3a275db8f77e2ec202884d612ee7f00b406cc892f74c175372486" => :high_sierra
  end

  depends_on "cmake" => :build
  # fix `'stdio.h' file not found` on macosx-10.13
  # open issue https://github.com/msoos/cryptominisat/issues/617
  depends_on :macos => :mojave
  depends_on :arch => :x86_64
  depends_on "boost"
  depends_on "python@3.8"

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", "/usr/bin/clang++"

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
    assert_equal "(None, True, False, True)\n", shell_output("#{Formula["python@3.8"].opt_bin}/python3 test.py")
  end
end
