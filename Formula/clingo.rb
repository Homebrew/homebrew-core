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
    sha256 cellar: :any,                 arm64_monterey: "f29085f4bfa5ef240893fb81f6fbcde373cbb556e4c0074f4afac1421fa4ff15"
    sha256 cellar: :any,                 arm64_big_sur:  "a07ba834cac742e0f312d043d162faef11b79599fb27c8ac9200296122d79fa7"
    sha256 cellar: :any,                 monterey:       "a00b67042ab1860d9e869a42e5ddff5a1dc1da8c73355da2e4403e7d0253c956"
    sha256 cellar: :any,                 big_sur:        "33cc22a9a997111f95660c59650360330c4bcf2c09e9af19194d8b6e927ab209"
    sha256 cellar: :any,                 catalina:       "cc7cd9a98981a3e5e9ada8377badbeb5d0c728cd0362b270a0d40546fccd35fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5bb283ac41fa30af663fbc4bf1568909026c842b5edd5a0504623ec4c618ce0"
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
