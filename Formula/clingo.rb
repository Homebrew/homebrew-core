class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.6.1.tar.gz"
  sha256 "fd94a8eadb0051abd0b7176e228404eeb93e0ad70307913a608aa4aa978fabec"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "59a702866b71893332c09d463aee424dbce467efee30fbaff0affb284fe545ac"
    sha256 cellar: :any,                 arm64_big_sur:  "4e7d7da17268f8c325dd5062b501d33020e7b697c4a5e3fc1c0c8a29477fe2c3"
    sha256 cellar: :any,                 monterey:       "65022b7095c2240d1f1355abd673a0536dd6809c0b25c428a5c731900e8000f8"
    sha256 cellar: :any,                 big_sur:        "fc01fe54d8d85abe30545ed1b77e2a85d4a304c33b588278ac4e145bb8f56a1d"
    sha256 cellar: :any,                 catalina:       "49527938d130b822cc499e4488a2a96e8ba078b613a7181f607a4fcb3c876493"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aced8c24d4ac698ea55b4c81685dcdafd97ed832a893d4e9f11fd5cf42a89ac2"
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
    system "cmake", "-S", ".", "-B", "build",
                    "-DCLINGO_BUILD_WITH_PYTHON=ON",
                    "-DCLINGO_BUILD_PY_SHARED=ON",
                    "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                    "-DPYCLINGO_USER_INSTALL=OFF",
                    "-DCLINGO_BUILD_WITH_LUA=ON",
                    "-DPython_EXECUTABLE=#{which("python3.10")}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end
