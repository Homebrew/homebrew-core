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
    sha256 cellar: :any, arm64_golden_gate: "0584c7e056a8c8046cfba1ab37ff94e35ff2b4636d4162d5870546b2289aa00a"
    sha256 cellar: :any, arm64_tahoe:       "7793bdca8de1ecaf72fd743f85fe381db98d4d48012b24eeeaa6cb0daa7ed41d"
    sha256 cellar: :any, arm64_sequoia:     "0d430699e034827936bc8a5d3fbc025336342b4b41c5fefd297213597a877bcd"
    sha256 cellar: :any, arm64_sonoma:      "36436058757a927821b83a13c7dc7015853e9a17adf775dcd07116d01233c479"
    sha256 cellar: :any, sonoma:            "7e9438c8d7720af3257eabe47d3388cda20d059df697e109de0bde62ef9a323e"
    sha256 cellar: :any, arm64_linux:       "17a6a186038072afc450f237ef285b2379be9496ac79cf2409cb5a82811bea01"
    sha256 cellar: :any, x86_64_linux:      "167a554ea8a966752d75a9aaa136c2578d6e125d1e276dc4caaebb281c8205cb"
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
