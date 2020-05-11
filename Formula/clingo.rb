class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.4.0.tar.gz"
  sha256 "e2de331ee0a6d254193aab5995338a621372517adcf91568092be8ac511c18f3"
  revision 1

  bottle do
    sha256 "768f983bdeb5b7ec3c2aa69b4df169d67df7ec9b0b3f666da4c0be2df84d106a" => :catalina
    sha256 "15877a90707bbe5e0c2d32511c53dac3eeda520ffa60ed65c85e5d6ee92be40c" => :mojave
    sha256 "c00105678551dd53f4ee59922422bdb9efd6691223daf132f26d8d8a4cc0bdfb" => :high_sierra
    sha256 "7a0478cea53e35f02d1f007690150263bbe0febccbdec892a5e83146ac79137f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python@3.8"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  # Patch adds Python 3.8 compatibility
  patch do
    url "https://github.com/potassco/clingo/commit/13a896b6a762e48c2396e3dc9f2e794020f4e6e8.patch?full_index=1"
    sha256 "f2840bc4ab5159c253c5390c845f0d003f5fef813f49ddca27dbd5245f535e79"
  end

  def install
    system "cmake", ".", "-DCLINGO_BUILD_WITH_PYTHON=ON",
                         "-DCLINGO_BUILD_PY_SHARED=ON",
                         "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                         "-DCLINGO_BUILD_WITH_LUA=ON",
                         "-DPYTHON_EXECUTABLE=#{Formula["python@3.8"].opt_bin}/python3",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clingo --version")
  end
end
