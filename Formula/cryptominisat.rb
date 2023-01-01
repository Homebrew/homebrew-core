class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.11.4.tar.gz"
  sha256 "abeecb29a73e8566ae6e9afd229ec991d95b138985565b2378af95ef1ce1d317"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f55031ebeb62eb54b08e6dc851bf0296d19d48b71e431f2eeb4a179590d0510e"
    sha256 cellar: :any,                 arm64_monterey: "60015d38637dfee5ff04d9566ff52d17408cda515ee76a1cd01557c7a60ee3a3"
    sha256 cellar: :any,                 arm64_big_sur:  "2bef2564da0b1b48add8b7bd153b3611abc839a1b555eb5ee70a290a5092f5eb"
    sha256 cellar: :any,                 ventura:        "7bea27778e26209a1535f3b491979191e00c89f3b8710ab1bb74fc635e6ffb2e"
    sha256 cellar: :any,                 monterey:       "b84162f9d9f5d1675fba871941bbe43f5a79558fde9928a7bfda8b1f7c0bd7a1"
    sha256 cellar: :any,                 big_sur:        "23a2a2e8d087e591ae8702a98e1660b4ec3c407c4ded2822c7c9f27cb83b1035"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e26b0ba0ec4f574eae058ba3609e8c3bfb383a5a82fbf2ce23ef94e250266991"
  end

  depends_on "cmake" => :build
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
