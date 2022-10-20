class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.99/extra-cmake-modules-5.99.0.tar.xz"
  sha256 "01818aa606628db57129f6e22dbae3532464220802d085c6e0689d032e87807e"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "884d3253f3869ebd934a6f78fad7520c294e06b60c6a32abb85bc169f445f225"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "884d3253f3869ebd934a6f78fad7520c294e06b60c6a32abb85bc169f445f225"
    sha256 cellar: :any_skip_relocation, monterey:       "7d6beac36a13914008c9523c16e554b898aae4da9374fa7718a3ad00037c03a8"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f6a67354f8466f479d036bc8850d34d0f1a039ac0c6298412609c731585f1ff"
    sha256 cellar: :any_skip_relocation, catalina:       "7d6beac36a13914008c9523c16e554b898aae4da9374fa7718a3ad00037c03a8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9515a77d062ededb7c0a06d51585d767026561903da4cfac3b29e42b0f3beb12"
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
