class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.18.0.tar.gz"
  sha256 "44b960a43c4eefc7f800ab5f3ec5c43f670c669e6bdec6a87b49138fedb0c34b"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "0254439ef6fca7d293141eb0649f4e8eadfa3f1d5040d37e2bffed911c1a1767"
    sha256 cellar: :any, arm64_tahoe:       "5f4b2fb751dbeb4d71bedcba41c795306af4e75a7c75f71d271ca0b6a49ba8e6"
    sha256 cellar: :any, arm64_sequoia:     "a4c1ec409bdeba093c2f089c102accdd84c9723b2c0056fce7bd0b5b82c01fc4"
    sha256 cellar: :any, arm64_linux:       "990d098ed30a7d7125993d8180af23c8dfb2e5ac295eef69f871723bcaef960d"
    sha256 cellar: :any, x86_64_linux:      "604bedae01b51f2cda2152c8cbd624da46ddf9a20ebdc65f27a7e0e872eabe09"
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
    url "https://github.com/meelgroup/cadiback/archive/802e1f6d34b6e613828e591a8359298cd99e6429.tar.gz"
    version "802e1f6d34b6e613828e591a8359298cd99e6429"
    sha256 "e9b29931f4d8e12a18eb12b862054af462332cf747be174eb9f7bdfdf4658918"

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
