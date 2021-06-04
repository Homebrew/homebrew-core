class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  stable do
    url "https://download.kde.org/stable/frameworks/5.82/extra-cmake-modules-5.82.0.tar.xz"
    sha256 "5972ec6d78c3e95ab9cbecdb0661c158570e868466357c5cec2b63a4251ecce4"

    patch do # Fix doc build with Sphinx 4, should be removed in new version
      url "https://invent.kde.org/frameworks/extra-cmake-modules/-/commit/001f901ee297bb5346729a02e8920b7528e20717.diff"
      sha256 "dc8425cffbf41d1ccb707e6fba1ee951b5af9fd7c299404388a46a29cc017f5f"
    end
  end

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1242ffd0fc1e65180a0f21e069ea4a4a91bbde2a7584be5a6aee6766bb9f1fae"
    sha256 cellar: :any_skip_relocation, big_sur:       "36e165723238c2bcef80f39c3b5581d1b267f84afd83ef707b8b5bf767c8953f"
    sha256 cellar: :any_skip_relocation, catalina:      "36e165723238c2bcef80f39c3b5581d1b267f84afd83ef707b8b5bf767c8953f"
    sha256 cellar: :any_skip_relocation, mojave:        "0a0dfafc74741320d2bbd3293de957d6f2137e07758da981c8f846f3eb07cc94"
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

    system "cmake", ".", *args
    system "make", "install"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(ECM REQUIRED)")
    system "cmake", ".", "-Wno-dev"

    expected="ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, File.read(testpath/"CMakeCache.txt")
  end
end
