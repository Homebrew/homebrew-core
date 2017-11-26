class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.2.2.tar.gz"
  sha256 "da1ef8142e75c5a6f23c9403b90d4f40b9f862969ba71e2aaee9a257d058bfcf"

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on :python if MacOS.version <= :snow_leopard

  needs :cxx14

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
