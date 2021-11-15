class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.88/extra-cmake-modules-5.88.0.tar.xz"
  sha256 "33bd83908daa531654455b77fc121b598f757aadf8ba01dbacfda8b8fb050319"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc264af38195c14c607e4a96e33cab0c0e353be296d369b44c198e50bbddb7b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1d30d324019e3a61b258c04ce13aa2031ce28bf68afcc262c7d890c7bbaec8c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d733e1d44f701b9f3a4d2b1867d4862c7e89e0f46b4726477a637158533125e"
    sha256 cellar: :any_skip_relocation, catalina:       "9d733e1d44f701b9f3a4d2b1867d4862c7e89e0f46b4726477a637158533125e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2a6093c65426e7978e61c99b886dd9ac30b9e25b79c1c1f2b13bbe0ae821b84"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_HTML_DOCS=ON"
    args << "-DBUILD_MAN_DOCS=ON"
    args << "-DBUILD_QTHELP_DOCS=ON"
    args << "-DBUILD_TESTING=OFF"

    system "cmake", "-S", ".", "-B", "build", *args
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
