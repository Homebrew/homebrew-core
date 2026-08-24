class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/clingo/"
  url "https://github.com/potassco/clingo/archive/refs/tags/v5.8.2.tar.gz"
  sha256 "af961e4e8122b9e1fa325ae20c98f0a17b2087e2c777832ae6e47025ec921331"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "e95810838c24931f9a858562a4b54f1256fd3133109146f33002a4383a50de43"
    sha256 cellar: :any, arm64_sequoia: "ba7d57a8181c4eea2b51b11e77464ad37b3c828fddceb726dd929dc2268a9dc4"
    sha256 cellar: :any, arm64_sonoma:  "b26d698136874ab953848a78d9007bb9dc52f0030567ab37a42c7df771b4fb61"
    sha256 cellar: :any, sonoma:        "f69dcbb6973c1a5a503f26b2f6315e71e9cfa5cdc86bd048fa683fd343e2deac"
    sha256 cellar: :any, arm64_linux:   "359298c5bd3fdece07490baf1e45ed557449c4a60036204f0d1249befb17c55d"
    sha256 cellar: :any, x86_64_linux:  "a06aebbfccc1dbe2eb145b426a0d1971fd91a207b05c84461ee29c67503ae4c4"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "cffi"
  depends_on "lua"
  depends_on "python@3.14"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.14")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCLINGO_BUILD_WITH_PYTHON=ON",
                    "-DCLINGO_BUILD_PY_SHARED=ON",
                    "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                    "-DPYCLINGO_USER_INSTALL=OFF",
                    "-DCLINGO_BUILD_WITH_LUA=ON",
                    "-DPython_EXECUTABLE=#{python3}",
                    "-DPYCLINGO_INSTALL_DIR=#{site_packages}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
    system python3, "-c", "import clingo"
  end
end
