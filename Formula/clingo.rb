class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.5.0.tar.gz"
  sha256 "c9d7004a0caec61b636ad1c1960fbf339ef8fdee9719321fc1b6b210613a8499"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256                               arm64_big_sur: "45807405ee5094521283506649145a4ba8eb90c0c395345baf6a8073e1915526"
    sha256                               big_sur:       "b8c3e08ce26ec66358081d0e151f5845eb8337be546fa2686b1bc62fb34e0575"
    sha256                               catalina:      "076f25a52597e885c64c2f15e1e4ba7628108515f6aff2f295cbe7931a4aaab0"
    sha256                               mojave:        "35659fc5b9b4572609f8d674a094b735233b7a5fbd8c93411c0d82c9a776aa2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f56220551aced5b0fc8d8300e7eaf4ab16c0078a955fe37cbaf0bda34feceb4c"
  end

  head do
    url "https://github.com/potassco/clingo.git"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python@3.9"

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
                         "-DPython_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end
