class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.92/extra-cmake-modules-5.92.0.tar.xz"
  sha256 "f89a238bc5f28738db25e29296b75b4f795e3e9bfe3a8f1f9390648749d303ef"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4f40b797e0f37f766d99a70ef242dba5b1dc1015d8be81bc9cc56372717e2a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "887bb033f5fa6f566a054561e9d09f20720bb84f72745e82d70f70b0f1e04e8a"
    sha256 cellar: :any_skip_relocation, monterey:       "bef6414c8bdd1ff1c4daa1c9b3390a5f4d1e5d57c31b2284a34242209b270605"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30f8da89c3cd5959be6d6e19990b0fb4e657f5a7db27d8b318548bc053e5235"
    sha256 cellar: :any_skip_relocation, catalina:       "d30f8da89c3cd5959be6d6e19990b0fb4e657f5a7db27d8b318548bc053e5235"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f02da5f94c799ad5178e520df02c95fd3301d36a351c21aa0ddaa51fe5bfd21c"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end
