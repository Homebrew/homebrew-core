class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.5.2.tar.gz"
  sha256 "a2a0a590485e26dce18860ac002576232d70accc5bfcb11c0c22e66beb23baa6"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "3628521f8f8432d6c3a8237f94dc3e7420ecb84548be1f817ac3062cd99d0e21"
    sha256 cellar: :any,                 arm64_big_sur:  "7be9c265337998fe4835c996392e33474bedb118e7d5564d2372e2c3c5be2bcc"
    sha256 cellar: :any,                 monterey:       "37e2d1395b65a9f673466a3db6bd203e015f7d61545bb1fca742cedc1be1fcd7"
    sha256 cellar: :any,                 big_sur:        "5f86b138d115622f928025c5fdf78be6c951ff3d6c1251a69ea4f0c2a5696c16"
    sha256 cellar: :any,                 catalina:       "080ce5cca826f9e0f070d078796d5c1331fc5782535e35a264a8ae8edeabae88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c32fb62a31beb556b98166cbf7c355c9eb81f247cf5778b018fa6f53593734d"
  end

  head do
    url "https://github.com/potassco/clingo.git"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python@3.10"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def install
    system "cmake", ".", "-DCLINGO_BUILD_WITH_PYTHON=ON",
                         "-DCLINGO_BUILD_PY_SHARED=ON",
                         "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                         "-DPYCLINGO_USER_INSTALL=OFF",
                         "-DCLINGO_BUILD_WITH_LUA=ON",
                         "-DPython_EXECUTABLE=#{which("python3")}",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end
