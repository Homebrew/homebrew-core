class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.5.0.tar.gz"
  sha256 "c9d7004a0caec61b636ad1c1960fbf339ef8fdee9719321fc1b6b210613a8499"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ee40dc322c872ceab0d5840e0cf7e0c17029338294308f60e793344f7f07232"
    sha256 cellar: :any,                 arm64_big_sur:  "982e57b5894a3927249e58909dc0f690411ce6ad643915063e3b711ae85ca097"
    sha256 cellar: :any,                 monterey:       "a52798cf560cda4619f370d6212dbc23fa8d0efc1c151c0386dfde11b89424dd"
    sha256 cellar: :any,                 big_sur:        "def9e572f86af37409a0f4f908e7caee183888b9ea506403464f3ce7d26a0bbc"
    sha256 cellar: :any,                 catalina:       "472868ff2dbf256f9cf8b01055b6a041b5a4ec1a1ecf83869f82e8367d3de007"
    sha256 cellar: :any,                 mojave:         "67e741141731249081fd2b4c24fac088f1a5020a6a2028606cd6e1623d51a7b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e819113cc9c7a5440d8509c654e3592377d9429f7a65ba88e6783dbfe6436138"
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
