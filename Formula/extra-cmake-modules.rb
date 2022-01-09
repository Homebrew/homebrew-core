class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.90/extra-cmake-modules-5.90.0.tar.xz"
  sha256 "f3007c3ceca56249292cf340a38518589a55a4afcf27e166ab63c5ac8ffabcb0"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2e92bee7988d65bc6682fa8a4df61d9e71664adff03c071e11c5e1350df060"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f2e92bee7988d65bc6682fa8a4df61d9e71664adff03c071e11c5e1350df060"
    sha256 cellar: :any_skip_relocation, big_sur:        "61f9cbf0e3a0870c06a4c00c82c3333b6c2a6925a2d6132e15339c3f9abb7111"
    sha256 cellar: :any_skip_relocation, catalina:       "bd73dfb643376ec06bf7e38a32e3d1362c4ea75dc5795d97c1d8b613ca9f5d3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9a071bb99ecf0294f12eaf7c15f451ce80ab71d33332ffdcbfbd8acb9071db7"
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
