class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/clingo/"
  url "https://github.com/potassco/clingo/archive/refs/tags/v5.8.3.tar.gz"
  sha256 "25d22cc25f95a8e7a8bac94cbe24b812574de9320250bdcb9d7f7e9e58c2a0d0"
  license "MIT"
  compatibility_version 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c0ca281d75541169a2e0d96f15c9124d19275190d326e36dd2fc9181b4d900d6"
    sha256 cellar: :any, arm64_tahoe:       "06e5319794a0356d7af5d51ab931a345d139fee4ac45f9f20c381d46663862d9"
    sha256 cellar: :any, arm64_sequoia:     "d8c51dd05900aabd0540447c84a194edf3498b47c8892f76a30e37f6f3a75a09"
    sha256 cellar: :any, arm64_linux:       "d812aad6e13116d73ab430109a298b4f849fa334a81bd353a634ad36fd6b47ff"
    sha256 cellar: :any, x86_64_linux:      "3f91437caba22bf1ba618b8bbeb65af3540456ddb8a50113b31fc779e1a8edb8"
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
  depends_on "python@3.15"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  deny_network_access!

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
