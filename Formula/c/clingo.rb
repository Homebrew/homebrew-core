class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/clingo/"
  url "https://github.com/potassco/clingo/archive/refs/tags/v5.7.1.tar.gz"
  sha256 "544b76779676075bb4f557f05a015cbdbfbd0df4b2cc925ad976e86870154d81"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "8e5be49e6063cf80941192bf2220a678e5829079692a66428f27e017f949d9d1"
    sha256 cellar: :any,                 arm64_sonoma:  "9c67786766375e1e7512170cc52c16a9ef58d1c81ac7466279fdc4335051efaf"
    sha256 cellar: :any,                 arm64_ventura: "dbdf5f8ae9de6a7779cc2bee5a4d6e890f8bdad5fa3535c1897739685a4f3c08"
    sha256 cellar: :any,                 sonoma:        "aaf82b17129c9e137b41dd5915e1135f4de0900d73e155e1873a8d45a7646e5a"
    sha256 cellar: :any,                 ventura:       "4382263c5c5fb381544df8158138cbafd982b3b2ee26ae3082cc6d2f1bb422c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ed3aded3facd05a4372bfb4c4a4112b89762af2da0e9e858dc09918f17e6937"
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
  depends_on "python@3.13"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.13")
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
