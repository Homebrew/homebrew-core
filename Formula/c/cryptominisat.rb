class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.14.7.tar.gz"
  sha256 "4d59b5af77ea632901b95e884adaaacc976a6822c440d9757eaa374290fd953f"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "7793bdca8de1ecaf72fd743f85fe381db98d4d48012b24eeeaa6cb0daa7ed41d"
    sha256 cellar: :any, arm64_sequoia: "0d430699e034827936bc8a5d3fbc025336342b4b41c5fefd297213597a877bcd"
    sha256 cellar: :any, arm64_sonoma:  "36436058757a927821b83a13c7dc7015853e9a17adf775dcd07116d01233c479"
    sha256 cellar: :any, sonoma:        "7e9438c8d7720af3257eabe47d3388cda20d059df697e109de0bde62ef9a323e"
    sha256 cellar: :any, arm64_linux:   "17a6a186038072afc450f237ef285b2379be9496ac79cf2409cb5a82811bea01"
    sha256 cellar: :any, x86_64_linux:  "167a554ea8a966752d75a9aaa136c2578d6e125d1e276dc4caaebb281c8205cb"
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
    url "https://github.com/meelgroup/cadical/archive/394c3f72858c2fe8cd35321f74f11f0f61c91123.tar.gz"
    version "394c3f72858c2fe8cd35321f74f11f0f61c91123"
    sha256 "68756da68674bdd689e9ac7735ab98363c9dca8ee0c7369b2083be0daabf7039"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback/archive/3b6a84062b1304433eb8960a4bff6b9a80de9c54.tar.gz"
    version "3b6a84062b1304433eb8960a4bff6b9a80de9c54"
    sha256 "336fcaa8a205fd70230ceabb28795e24e7c91b907cd7d811056368783f0770b5"

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
