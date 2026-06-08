class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.14.5.tar.gz"
  sha256 "1deb009ffc832382529e72da804480696e9cd8f51117b2202907a13866b96a2a"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0bda535d69f0df6273e6a67cafc16d1525d1a15d77926f9180f1d396b798f5eb"
    sha256 cellar: :any,                 arm64_sequoia: "4119f4cdc2d9689710e3dfb37df48e23ef326a5791be39fd17ced13e67cc488a"
    sha256 cellar: :any,                 arm64_sonoma:  "3643904b54eb5e7884f0d9c18b81b27c546346b7f8e88a2b3ed26c4c18543b52"
    sha256 cellar: :any,                 sonoma:        "0e0bb28190d8c36f9d3020ad5fc44cd48a710e43723f50368ed9a13453493230"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24d1c38e04966c1ab76c292541804e7e5a15114c6a40ae70f02d4d9a2961d39a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "448cb62862b4de1f036708fe68097903d03ea9314e6f1269091a6bba2c5d026e"
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
    url "https://github.com/meelgroup/cadical/archive/ade472d3dba145fd53c19d486f5916b6259449c6.tar.gz"
    version "ade472d3dba145fd53c19d486f5916b6259449c6"
    sha256 "fc42be82d65bab670b6e100db18776048e5e506a8a6aa12da64873e3f5bf8d03"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback/archive/35f027383abf3b4b52bbc8af789c8f1aa3d84ad2.tar.gz"
    version "35f027383abf3b4b52bbc8af789c8f1aa3d84ad2"
    sha256 "c0066295ccf209617e18eba89d5fc8b3d4baabf2184441bdaea600add32a2453"

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
