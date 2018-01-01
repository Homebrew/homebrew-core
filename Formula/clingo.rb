class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.2.2.tar.gz"
  sha256 "da1ef8142e75c5a6f23c9403b90d4f40b9f862969ba71e2aaee9a257d058bfcf"

  bottle do
    rebuild 1
    sha256 "c6d1544f386880a1c16c81f56fddc3bef9efccda62d624dc646e6e785a236301" => :high_sierra
    sha256 "69df2be35e41efc97550deef3f12a66210a77838b4238e9046edf2aab9a38a25" => :sierra
    sha256 "7c9b87455116a0538ff4e8de9a2366a7ae7cb0020ef9c8a38450a72efd4903ce" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python" if MacOS.version <= :snow_leopard

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
