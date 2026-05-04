class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.14.4.tar.gz"
  sha256 "cc8ff7bd6aa72cf0ba1d4cb6aa0f430f4fc6155af4e9d29008acc06b2583087e"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "b2d71c29e673f8fe425c63848154ef5e824de624268023a9e56fe9f3b99b6d0f"
    sha256 cellar: :any,                 arm64_sequoia: "5239fb1cf825cfdfbb4a697a5c3009b1e5899c8a74ea64fcf932f9fc961fd268"
    sha256 cellar: :any,                 arm64_sonoma:  "69bc8c2ca51ab1df9daef08ef1ed3eacd438d8d6125b1d659206e1f692381ff6"
    sha256 cellar: :any,                 sonoma:        "a67f35b0592b480831b2463a17dab5f7d9f637eea03d27d3c469f59be807b25f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b60138350eecaff614b7ed419457f26e4a837d2155c826c49e40e8bc5c9a50e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c56b827004dd4770e742065676caaf01eb3cae78ef4888502ad2b42273d7b42"
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
    url "https://github.com/meelgroup/cadical/archive/1652f668becc717eb14c184a727864c1937082d6.tar.gz"
    version "1652f668becc717eb14c184a727864c1937082d6"
    sha256 "d8abdf8a846ced6964da08118900d841d55471c2cb808b6c81cb6b8671b5671e"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback/archive/300818c10cac0053dd27650a7d9cd58dfe08b3fe.tar.gz"
    version "300818c10cac0053dd27650a7d9cd58dfe08b3fe"
    sha256 "07e1c2a891e0f0d8732392bb4e8c3279b1dc7947a4854d14ac3448c52530d95c"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadiback", "locked", "rev")
      end
    end
  end

  def python3
    "python3.14"
  end

  def install
    # fix audit failure with `lib/libcryptominisat5.5.7.dylib`
    inreplace "src/GitSHA1.cpp.in", "@CMAKE_CXX_COMPILER@", ENV.cxx

    # Revert msoos/cryptominisat@50b87734's PRIVATE -> PUBLIC; export leaks break consumers
    # main.cpp uses GMP directly so link it explicitly into the binary too.
    # Issue ref: https://github.com/msoos/cryptominisat/issues/820
    inreplace "src/CMakeLists.txt" do |s|
      s.sub!(/^    PUBLIC\n(        Threads)/, '\1')
      s.sub! "target_link_libraries(cryptominisat5-bin\n    PRIVATE\n        cryptominisat5\n",
             "\\0        PkgConfig::GMP\n"
    end

    resource("cadical").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath/"cadical")
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    resource("cadiback").stage do
      inreplace "CMakeLists.txt", 'set(CADIBACK_BUILD "${CMAKE_CXX_COMPILER}")', "set(CADIBACK_BUILD \"#{ENV.cxx}\")"

      args = ["-Dcadical_DIR=#{buildpath}/cadical"]
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
