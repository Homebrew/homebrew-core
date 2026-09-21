class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.15.0.tar.gz"
  sha256 "274016b8440716897e84c12e6f94ff607017cfa427a3319cac253177594d6b28"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d1fa3a2099c5177b22be17aa1238b5a641f5d9163627aee1ff912c3edf09d63c"
    sha256 cellar: :any, arm64_tahoe:       "1e09ba0cc5fcb044421ec175381dc1b566edd22222a9569c97cb901639ff368e"
    sha256 cellar: :any, arm64_sequoia:     "2187367adc01c4c6bc31ecc4fc6075faf08e4b4cba8c489c2c92a3fa822f0688"
    sha256 cellar: :any, arm64_linux:       "436bd9726c057908f76ed4e060775f7009fb88395fe487bfc2a7b32ec1e94398"
    sha256 cellar: :any, x86_64_linux:      "19cbdf088a5733af2642c77c38bb9613974d1aa9d06c8c5801d94817184bac71"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.14" => [:build, :test]
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
    url "https://github.com/meelgroup/cadiback/archive/47a6d821085ef8cb033241659824beafeb798cff.tar.gz"
    version "47a6d821085ef8cb033241659824beafeb798cff"
    sha256 "ccc2faf23c78ba22e2c73bb8c8ebe33995083dce77ee0ca8eb7ee3009955d9c4"

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
