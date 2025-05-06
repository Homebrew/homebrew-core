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
    sha256 cellar: :any,                 arm64_sequoia: "35d24c0f73cd44d4c42517ba3621df5d6a400ff7f4fd8306cc2f4622d40b008f"
    sha256 cellar: :any,                 arm64_sonoma:  "e76e8773450698143ffdacc0bfc1d489caada722d4b2bd5714b66b4a5d0c59fe"
    sha256 cellar: :any,                 arm64_ventura: "2db3b04fe55e9957addd3bbc2e7a211a9b1be4d114b3b5b04795f1a0576659ed"
    sha256 cellar: :any,                 sonoma:        "ee580dd3486d3a83a0b71d5a3a9f0c3853862004079e3cb36e5c03226ff7f74a"
    sha256 cellar: :any,                 ventura:       "acf4bec16f8de6c2f8c5d3c9139dc607a2d9ebfbb44da8777bfd4f84af449f9a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6b945753340a64e78a96e4aa1f030e9f5734937c33111c948be3e25cac089d5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bcb0aa794aab95ff9376eaf61ecd30a803bdde61cf061998881b734687bdaedf"
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
  depends_on "python@3.13"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.13")
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
