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
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "dfec1f0eb737df1bd9b4fad7cddf317b1ffb6955159d239a4365254d0377555e"
    sha256 cellar: :any,                 arm64_monterey: "345c187bc69d49333751f96f99290c956b158e27866b3eabc435cdcfbc65292e"
    sha256 cellar: :any,                 arm64_big_sur:  "5e2632bbee295c7cc2a9ba8eed350239727de547ba260a9a40b0f229b7cac832"
    sha256 cellar: :any,                 ventura:        "70968734320df38092e4b76df17341d2a922af27f1ea5098a88ac92c9571986f"
    sha256 cellar: :any,                 monterey:       "f2aeaa02f678c37d887abf3e7d21bb87415e52ab58b7ea06dc713ee31113c004"
    sha256 cellar: :any,                 big_sur:        "8d6b17dde67f90a30393cf1d6a23eec982cf9ba7bad8ac3f3ea295f3212e8a08"
    sha256 cellar: :any,                 catalina:       "b426635cba6344e6c8a3935652d2857b1b8b8bfd16686f772f08b969477aea73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "291dea6ecc98e356b73b7c2e85d062d6e8cd4a6b91e8e3fd220f38c4fcec4ef0"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python@3.11"

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
                    "-DPython_EXECUTABLE=#{which("python3.11")}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end
