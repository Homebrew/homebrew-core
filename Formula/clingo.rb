class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.2.2.tar.gz"
  sha256 "da1ef8142e75c5a6f23c9403b90d4f40b9f862969ba71e2aaee9a257d058bfcf"

  bottle do
    sha256 "0f3d85155c09630f853a8e0c96c370ee17b233311d1dcf4f4a26b2e8fd448b31" => :high_sierra
    sha256 "8485fdbf8ee52b6009b4ae1bebeba6aa35a561f3b0fbd1f784a9bb5d9cc59f55" => :sierra
    sha256 "d1582e8cce6bec425bb6d04c6c30223203daadb5abf14c62628219d8a569240a" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  needs :cxx14

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
                         "-DCLINGO_BUILD_WITH_LUA=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clingo --version")
  end
end
