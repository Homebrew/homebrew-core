class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.11.tar.gz"
  sha256 "20efedfab285293eb8c9804939b5298e43071489c8b09e135e118aec54f682bc"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8e907ec4f33fba7ec64b46f9393189fc11bdc2192182882da7d5390db6912779"
    sha256 cellar: :any,                 arm64_monterey: "f81c55dc4589092427df6780683e93b86d68094f5b62ce0afb27b01eff88d5c0"
    sha256 cellar: :any,                 arm64_big_sur:  "c118a63a3a3b450fd6a7bfbafe4a82a343207655766b729b5bc51f6e6ccca426"
    sha256 cellar: :any,                 ventura:        "13e87a692679f6c3c443096ab4038de98d656e5397a9b99da1d46223ce0aeda6"
    sha256 cellar: :any,                 monterey:       "a8a194eccee06a03623f2a4ed913ab643ba267b4c2a1602e7ee8f6e826d397f1"
    sha256 cellar: :any,                 big_sur:        "da9e09f77d1bcd2323232171bf8faf5dc813d33dc0e76dcab68f014280b161c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "05219a8badbad06bd37007e2e2b555dd6bffc3edb7ec864a17416cc847872af8"
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
