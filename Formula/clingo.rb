class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.3.0.tar.gz"
  sha256 "b0d406d2809352caef7fccf69e8864d55e81ee84f4888b0744894977f703f976"

  bottle do
    sha256 "2e8a34ad07eb87362981512cfe327c70e4305bbfc831bc8338a3ee652bfbf915" => :high_sierra
    sha256 "4853e4bf71f3cd05c7f68e6652f8b36e218c549f4033c37f2e137326a51f7acd" => :sierra
    sha256 "1a77e6bf8ce30c67fda7a53ae70906e4d61c951475037f8e0951649eb04d26eb" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python"

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
