class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.3.0.tar.gz"
  sha256 "b0d406d2809352caef7fccf69e8864d55e81ee84f4888b0744894977f703f976"

  bottle do
    sha256 "7d5361d6a0eeae3dd864ca98abcca889c6020d3e6b00158065d2a22bb07ef247" => :mojave
    sha256 "3e86b87aafa82aec26e952283c53f64a4856a7e7baae383c75f76e48fdea36ad" => :high_sierra
    sha256 "2c5f76428bc4b2ee00588770b95de5793a7cd3aac22cdbf211e48df4c260f3fb" => :sierra
    sha256 "29f93ed547c63e8881840cf9dd6b68b154cbff5436a002ddc584f16789e44fc3" => :el_capitan
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

  needs :cxx14

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
