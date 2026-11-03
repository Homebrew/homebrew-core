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
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "ff71cd7e240e1d2be2a10f379f2b488a0b6cbc3f5461708ed21b4a64c0beafc9"
    sha256 cellar: :any, arm64_tahoe:       "3e8077c2bfe774d3d439dc3044c1ea9fb9133f9fd5df54bfe553abf75750d778"
    sha256 cellar: :any, arm64_sequoia:     "0c1f507bbae0bacf1367f5be75dd884e3f222eb0d749f7fec37d6d13b0eb907e"
    sha256 cellar: :any, arm64_linux:       "2641ceea5b9474c83e4ee3d1331ea7b8e8433320568450e546aa9192795a6ab0"
    sha256 cellar: :any, x86_64_linux:      "9159f4257afae3da41b0c8821f787490c1f3a960b13dbf11fae0ca85956c1474"
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
