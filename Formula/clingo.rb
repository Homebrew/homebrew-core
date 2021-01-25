class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.4.1.tar.gz"
  sha256 "ac6606388abfe2482167ce8fd4eb0737ef6abeeb35a9d3ac3016c6f715bfee02"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "6f4b60fa6d911b4740a30b6ccfa4d4014afb3b854027353ec59ad6e93e706ef4" => :big_sur
    sha256 "b32ff9822ef258cf9eb034e7777ab748a57ae0c41d8dff7eddf1631dfb1acf6b" => :arm64_big_sur
    sha256 "a009c8c0bfd4a47c515d94ad7d779a906e1ca8a69a99b5361d44314b750920ef" => :catalina
    sha256 "c13ee502b4f99f4f8b9164a020262fdac0d557eb1527f932b798886efbacd012" => :mojave
  end

  head do
    url "https://github.com/potassco/clingo.git"
    depends_on "bison" => :build
    depends_on "re2c" => :build
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

  def install
    system "cmake", ".", "-DCLINGO_BUILD_WITH_PYTHON=ON",
                         "-DCLINGO_BUILD_PY_SHARED=ON",
                         "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                         "-DPYCLINGO_USER_INSTALL=OFF",
                         "-DCLINGO_BUILD_WITH_LUA=ON",
                         "-DPython_EXECUTABLE=#{Formula["python@3.9"].opt_bin}/python3",
                         "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                         *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end
