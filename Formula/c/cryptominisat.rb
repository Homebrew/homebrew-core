class Cryptominisat < Formula
  desc "Advanced SAT solver"
  homepage "https://www.msoos.org/cryptominisat5/"
  url "https://github.com/msoos/cryptominisat/archive/refs/tags/release/v5.14.3.tar.gz"
  sha256 "0ed3b7ec51ae44a9c58858459552b58783b6ab5663b11b79a8289de4b9ed6cab"
  # Everything that's needed to run/build/install/link the system is MIT licensed. This allows
  # easy distribution and running of the system everywhere.
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    regex(%r{^(?:release/)?v?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "793241bdc8bff995a4db02cce9bda882ab6e148011f92a4f5e9b59e41a79edee"
    sha256 cellar: :any,                 arm64_sequoia: "213c68da9d40f83b531728a8693da5b69b1ca5397c70e37d4c5090e2fcf08ff7"
    sha256 cellar: :any,                 arm64_sonoma:  "75233926b63055af5ae7274e0ec09746393eb43a180732832935fab093d88925"
    sha256 cellar: :any,                 sonoma:        "1ad17d8a2bf7e6135a86b97af2b16e206c0fb7578c7fdd7317b21bdec700c4e0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ba0cbf372ec2733828781b1f981552a061424eafdcde43273a132b4841f1474"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ebc4fe546bc60bf4c13c60e2350cb905caf69b6ead1db90dd6250d16376570f0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.14" => [:build, :test]
  depends_on "gmp"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  # Currently using revision in flake.lock
  resource "cadical" do
    url "https://github.com/meelgroup/cadical/archive/25c12aac83fd2f8627ca5c9a82cd864feea8783f.tar.gz"
    version "25c12aac83fd2f8627ca5c9a82cd864feea8783f"
    sha256 "d36995e5bac5feb6503ae76f201a618da26cbca414284a6caf33c71a9a835f54"

    livecheck do
      url "https://raw.githubusercontent.com/msoos/cryptominisat/refs/tags/release/v#{LATEST_VERSION}/flake.lock"
      strategy :json do |json|
        json.dig("nodes", "cadical", "locked", "rev")
      end
    end
  end

  # Currently using revision in flake.lock
  resource "cadiback" do
    url "https://github.com/meelgroup/cadiback.git",
        revision: "798d069b99e030ddb4e612fb6ef7ccaaa2d3a5e5"
    version "798d069b99e030ddb4e612fb6ef7ccaaa2d3a5e5"

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

    (buildpath/name).install buildpath.children
    (buildpath/"cadical").install resource("cadical")
    (buildpath/"cadiback").install resource("cadiback")

    ENV.append_to_cflags "-fPIC" if OS.linux?

    cd "cadical" do
      system "./configure"
      system "make", "-C", "build", "libcadical.a"
    end

    cd "cadiback" do
      system "./configure"
      system "make", "libcadiback.a"
    end

    site_packages = prefix/Language::Python.site_packages(python3)
    args = %W[
      -DBUILD_PYTHON_EXTENSION=ON
      -DCMAKE_INSTALL_RPATH=#{rpath};#{rpath(source: site_packages)}
      -DMIT=ON
      -Dcadiback_DIR=#{buildpath}/cadiback
      -Dcadical_DIR=#{buildpath}/cadical/build
    ]

    system "cmake", "-S", name, "-B", "build", *args, *std_cmake_args
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
