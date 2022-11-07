class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.6.2.tar.gz"
  sha256 "81eb7b14977ac57c97c905bd570f30be2859eabc7fe534da3cdc65eaca44f5be"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "621ccef3c189f4c015cbf1ff0b1f9a597fa91257d52a9cca853e62da56e5baed"
    sha256 cellar: :any,                 arm64_big_sur:  "ee341a847e77fc910595d731249895b66b9e35f25f3c19f0467a07b2080b35bc"
    sha256 cellar: :any,                 monterey:       "8a1d9f184b0ad6a5dedc6cdb7f028fd98cfe4b409cce3dbfec0244463c48972c"
    sha256 cellar: :any,                 big_sur:        "239af88ffbcff1a2454474c8ae4aba593a7e72cfed6f115d4466bffbaf9d5258"
    sha256 cellar: :any,                 catalina:       "213b5843540258c6b4c8d02e58413854063161f013516e3a6fca5e22287ad197"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49c06c20e531baf8639afa31c3edb57bf830565334f1d313c3402a599427ba56"
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
