class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/clingo/"
  url "https://github.com/potassco/clingo/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "4ddd5975e79d7a0f8d126039f1b923a371b1a43e0e0687e1537a37d6d6d5cc7c"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f4a0ef85978edfdfb395006c8ce603575282b12859dc1d25fe2edf6e57d9879b"
    sha256 cellar: :any,                 arm64_sequoia: "75b64a722804b1c96506cc085e207c8f3cb3e14b23b0836dbac7a2ee9170f64f"
    sha256 cellar: :any,                 arm64_sonoma:  "71587c5bf9b5336b95d5c62170e2515978065f398f85dab7bbdb3831e38d007e"
    sha256 cellar: :any,                 sonoma:        "062bf230ada4dbb858940bf7316dd2f9b217b6d92fb2cc8543ddf38633e97a8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "608cc630ce095d1f32ad28dd0105a54e69aecbb38340e33883dd8e6747713e02"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c13546d050e4d818f0e7aba365840f6e1d825e1a1ac1de4e10249e8821305f9"
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
  depends_on "python@3.14"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.14")
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
