class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.6.0.tar.gz"
  sha256 "2891ecfcccbe728168ac27d62c3036aae0164b15b219b4954fb18614eda79f53"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "516d1802c4d72a58f5a29333619d9368fe86be8271585c8a2538e5f4f7e1315c"
    sha256 cellar: :any,                 arm64_big_sur:  "24a2afa23f80f6d606a79df6884979834596fa20d80b4c1d2c7d371e7b401a99"
    sha256 cellar: :any,                 monterey:       "5a95cbc5c5feff84a3f273632901aa64bd7e9a0308d7d362be2841b85fc212b4"
    sha256 cellar: :any,                 big_sur:        "0601e130693a5907c3202794c0ff054f2764b891e829be9c0e45b9748bd41e25"
    sha256 cellar: :any,                 catalina:       "8e5a8a8cbcafbf382075fb9a1cad3c378e04f37ddcc93fb63a545b25936e5f05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff669faa185e5071638026628e823ee24b647e72c21cdee41c00305e16bea8cf"
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
