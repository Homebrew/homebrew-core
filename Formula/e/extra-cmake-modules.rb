class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.109/extra-cmake-modules-5.109.0.tar.xz"
  sha256 "1526b557cf9718e4d3bf31ff241578178d1ee60bdfb863110c97d43d478b7fb7"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7a655248046b1117e2625e11b702c6197c4c0f45c2ebbb30d4b8518f1b5bcd0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a655248046b1117e2625e11b702c6197c4c0f45c2ebbb30d4b8518f1b5bcd0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "756f40cedf878f3817ea69d8230e0937eaa2fc44e420ccb0575618232634046b"
    sha256 cellar: :any_skip_relocation, ventura:        "4818f19a4aa11710bdfb78e8674c7c023fcf169a429abb3acf1b06edd97e4abb"
    sha256 cellar: :any_skip_relocation, monterey:       "4818f19a4aa11710bdfb78e8674c7c023fcf169a429abb3acf1b06edd97e4abb"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad3c3be10a8db3d44fda754e420e542f7203a3cb91b9b81a7f96dfa78edcaf8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c725c6aa81b11a5de654534d043ea81861b12d90e4ad8a2e1e11de54a2afe1b9"
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
