class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/5.8.0.tar.gz"
  sha256 "50153025c8503ef32f32fff847ee24871bb0fc1f0b13e17fe01aa762923f6d94"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1

  livecheck do
    url "https://github.com/msoos/cryptominisat.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "c203b2037a55507235aa4a64f35d7a96bf6af7913c27b64057fa61cc55a4b012"
    sha256 big_sur:       "982f3dc69641c5c0e49857173283d732f631c228ce167a5fab142aa83b39d137"
    sha256 catalina:      "4a3a5a12f7a19dea74436a5fd0de9f2dd848dbe7cfdd951dcdbf620822de32ab"
    sha256 mojave:        "df9c576ce0f8b786cdbfbfd724e97196fa1e776447cf9df50e8ec7890ed509f3"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "python@3.9"

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", "/usr/bin/clang++"

    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DNOM4RI=ON", "-DCMAKE_INSTALL_RPATH=#{lib}"
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
    assert_match "s UNSATISFIABLE", result

    (testpath/"test.py").write <<~EOS
      import pycryptosat
      solver = pycryptosat.Solver()
      solver.add_clause([1])
      solver.add_clause([-2])
      solver.add_clause([-1, 2, 3])
      print(solver.solve()[1])
    EOS
    assert_equal "(None, True, False, True)\n", shell_output("#{Formula["python@3.9"].opt_bin}/python3 test.py")
  end
end
