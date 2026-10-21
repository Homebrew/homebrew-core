class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.17.0.tar.gz"
  sha256 "376f3ee70815037a175e54631162232785da343ca9436faa929e6863648e5f92"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  revision 1
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "98123e138ebaa54ea98ed4af772b815e463a16070f84499f93958cbba2e4e573"
    sha256 cellar: :any, arm64_tahoe:       "f27be39f2ecf402ed302d5b9eb9b259a04212235d1c3275e3d57dbbc9bcd34da"
    sha256 cellar: :any, arm64_sequoia:     "e00b73ab613b015a1aa370c2d75d541f4477e27375e5c101a60b77cb2bf471fb"
    sha256 cellar: :any, arm64_linux:       "b8bfc3d85508d13dbcfba6387d9be9669361d76370fcc7dab0f5123ece36ddaa"
    sha256 cellar: :any, x86_64_linux:      "d5978f9a937f31d3ea855cd97cc092095e64f4b39b2ca4d2143a4aec7f36aa59"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.15" => [:build, :test]
  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Currently using revision in flake.lock
  resource "cadical" do
    url "https://github.com/meelgroup/cadical/archive/818c9562f114b315a9246ced943b66b60b38e8fb.tar.gz"
    version "818c9562f114b315a9246ced943b66b60b38e8fb"
    sha256 "beaeb17a751db88d5384b35d65be82501d94cf60f758b768b59bfb2b437cb34b"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback/archive/445ddc2f2b5e54421af64e0652c2eb8444175322.tar.gz"
    version "445ddc2f2b5e54421af64e0652c2eb8444175322"
    sha256 "9682f83ead35e1339a2fafdfdbc8d4047b313ee64cafa9285861c0d13f5aa2a1"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadiback", "locked", "rev")
      end
    end
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # Build static libraries as these are only installed into `buildpath` to link into cryptominisat
    resource("cadical").stage do
      inreplace "src/cadical_gitsha1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

      args = ["-DBUILD_SHARED_LIBS=OFF"]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: buildpath/"cadical")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("cadiback").stage do
      inreplace "CMakeLists.txt", 'set(CADIBACK_BUILD "${CMAKE_CXX_COMPILER}")', "set(CADIBACK_BUILD \"#{ENV.cxx}\")"

      args = ["-DBUILD_SHARED_LIBS=OFF", "-Dcadical_DIR=#{buildpath}/cadical"]
      system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: buildpath/"cadiback")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      -DBUILD_PYTHON_EXTENSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}
      -DMIT=ON
      -Dcadical_DIR=#{buildpath}/cadical
      -Dcadiback_DIR=#{buildpath}/cadiback
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    site_packages.install prefix.glob("pycryptosat.*.so")
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
