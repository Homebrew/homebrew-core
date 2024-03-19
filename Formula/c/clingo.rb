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
    sha256 cellar: :any,                 arm64_sonoma:   "64ed41a472f7e07f81420c75bb13c6da83df9dac3fbe0c76c367669484e9eba5"
    sha256 cellar: :any,                 arm64_ventura:  "29bb65f2229c066ce1cd6621e3ae1d9526832cad125f7ae8ee6e3651418b9569"
    sha256 cellar: :any,                 arm64_monterey: "f2f79a6aa705a0d0f928512778cc70c0690ebe39cfd681652da7bb270ebc9679"
    sha256 cellar: :any,                 sonoma:         "c7f60a67614f9e1da49ab636b1b31cc2a0cecf3ba27ac80b0e03d9743c540491"
    sha256 cellar: :any,                 ventura:        "a63cf8d67cb344877cbc3ed65bf97d278c6bdec1506a2ee4b995ce1b53868693"
    sha256 cellar: :any,                 monterey:       "522e5cebd4a601f4f56a68d4daf006df5f80c9defd45f3c3a8c0b1478f4510b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b893cc6d7b66a55c58719b5d2dcd9708bf66168fd548162f29e044bd4fa26d8"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "cffi"
  depends_on "lua"
  depends_on "python@3.12"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.12")
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
  end
end
