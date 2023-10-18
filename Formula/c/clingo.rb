class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/"
  url "https://github.com/potassco/clingo/archive/v5.6.2.tar.gz"
  sha256 "81eb7b14977ac57c97c905bd570f30be2859eabc7fe534da3cdc65eaca44f5be"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "5fdce6f98b9e17062dca2b8aeb5cd544a71c16364319225602f480eef9b5e25f"
    sha256 cellar: :any,                 arm64_ventura:  "fc2dec92576fc7c8e1d2908d1b3dc63ed227007105d05351ea7785d3f2955478"
    sha256 cellar: :any,                 arm64_monterey: "934ce94683e8012945700adfb790f2d10b5e3f66298ada4b84ab4405328361db"
    sha256 cellar: :any,                 sonoma:         "fa16c6237a73f7f37b24a1a6cf0e901c44d53b4dac4a2c4a91dd3bff5bde8b33"
    sha256 cellar: :any,                 ventura:        "5434daa0b2a1790e5dd14b9796d86557f0fe80e2efb4d10c73eeed7c769f20ed"
    sha256 cellar: :any,                 monterey:       "8ff16e0968a394d6501e99a75e3653b545f839be496d5fbcaae544c824bdd57f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf6da48f4dede7d2e5f504c9712c4ee44e7ab7918e8cf63a4b4b0f6ffa618bc5"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python-setuptools" => :build
  depends_on "lua"
  depends_on "python@3.12"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/68/ce/95b0bae7968c65473e1298efb042e10cafc7bafc14d9e4f154008241c91d/cffi-1.16.0.tar.gz"
    sha256 "bcb3ef43e58665bbda2fb198698fcae6776483e0c4a631aa5647806c25e02cc0"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCLINGO_BUILD_WITH_PYTHON=ON",
                    "-DCLINGO_BUILD_PY_SHARED=ON",
                    "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                    "-DPYCLINGO_USER_INSTALL=OFF",
                    "-DCLINGO_BUILD_WITH_LUA=ON",
                    "-DPython_EXECUTABLE=#{which("python3.12")}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
  end
end
