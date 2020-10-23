class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.4.0.tar.gz"
  sha256 "e2de331ee0a6d254193aab5995338a621372517adcf91568092be8ac511c18f3"
  license "MIT"
  revision 2

  livecheck do
    url "https://github.com/potassco/clingo/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 "5e3cead6d5fde6357e4a9bfda2f7e1d4096682b83194906e011b0d04a0fe58cf" => :catalina
    sha256 "348efd367746175aef195ba411274d772af37bcdb320df395c19897fb56b1b22" => :mojave
    sha256 "e2f27e0830e735740f66646c50527e4601cae561a2e1c9e27ab12a36d88a0145" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "lua"
  depends_on "python@3.9"

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
                         "-DPYTHON_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/clingo --version")
  end
end
