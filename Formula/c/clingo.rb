class Clingo < Formula
  desc "ASP system to ground and solve logic programs"
  homepage "https://potassco.org/clingo/"
  url "https://github.com/potassco/clingo/archive/refs/tags/v5.8.0.tar.gz"
  sha256 "4ddd5975e79d7a0f8d126039f1b923a371b1a43e0e0687e1537a37d6d6d5cc7c"
  license "MIT"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7d606936da6a7f4091d200cf507e6d84dbadab7e44ccea7ddf1f85b04e1c92ec"
    sha256 cellar: :any,                 arm64_sequoia: "cadf7db4623f11e771514eb2a29b08625bffacb5e38289d7f6b8bf76ac84bf36"
    sha256 cellar: :any,                 arm64_sonoma:  "b6a25764a9f579481219b13cc37b85370e1711d65479ac5157aa174de25dfa38"
    sha256 cellar: :any,                 sonoma:        "0ce74dea22d40520801a1bad792df7cb8ea148b39f57fa7f24076beae86f01f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "295fb70cc8ee473656c529f06107ca59bd4b439fb98fc50af1db18003940a109"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "790e57292114c711904b97f44dfcd4f6bb09535f73b9d0e54d61f4e862d40156"
  end

  head do
    url "https://github.com/potassco/clingo.git", branch: "master"
    depends_on "bison" => :build
    depends_on "re2c" => :build
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "cffi"
  depends_on "lua"
  depends_on "python@3.14"

  # This formula replaced the clasp & gringo formulae.
  # https://github.com/Homebrew/homebrew-core/pull/20281
  link_overwrite "bin/clasp"
  link_overwrite "bin/clingo"
  link_overwrite "bin/gringo"
  link_overwrite "bin/lpconvert"
  link_overwrite "bin/reify"

  def python3
    which("python3.14")
  end

  def install
    site_packages = Language::Python.site_packages(python3)

    system "cmake", "-S", ".", "-B", "build",
                    "-DCLINGO_BUILD_WITH_PYTHON=ON",
                    "-DCLINGO_BUILD_PY_SHARED=ON",
                    "-DPYCLINGO_USE_INSTALL_PREFIX=ON",
                    "-DPYCLINGO_USER_INSTALL=OFF",
                    "-DCLINGO_BUILD_WITH_LUA=ON",
                    "-DPython_EXECUTABLE=#{python3}",
                    "-DPYCLINGO_INSTALL_DIR=#{site_packages}",
                    "-DPYCLINGO_DYNAMIC_LOOKUP=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "clingo version", shell_output("#{bin}/clingo --version")
    system python3, "-c", "import clingo"
  end
end
