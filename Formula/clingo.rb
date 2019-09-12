class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.4.0.tar.gz"
  sha256 "e2de331ee0a6d254193aab5995338a621372517adcf91568092be8ac511c18f3"

  bottle do
    sha256 "15877a90707bbe5e0c2d32511c53dac3eeda520ffa60ed65c85e5d6ee92be40c" => :mojave
    sha256 "c00105678551dd53f4ee59922422bdb9efd6691223daf132f26d8d8a4cc0bdfb" => :high_sierra
    sha256 "7a0478cea53e35f02d1f007690150263bbe0febccbdec892a5e83146ac79137f" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python"

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
                         "-DCLINGO_BUILD_WITH_LUA=ON",
                         "-DPYTHON_EXECUTABLE=#{Formula["python"].opt_bin}/python3",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clingo --version")
  end
end
