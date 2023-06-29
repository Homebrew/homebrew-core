class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.107/extra-cmake-modules-5.107.0.tar.xz"
  sha256 "3969aad56d1e6a5901e926aaf7a73510d98c4b363564ed3f1222d4135da633ed"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbab540f7a766e4b3a76e39846057ea3f59414e0f5cb85c8193f8b4330f8bb71"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a8bb98a517e9df58ffca2d02e095c2464bc970321ccd4b402fd0e02cdc5e66ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbab540f7a766e4b3a76e39846057ea3f59414e0f5cb85c8193f8b4330f8bb71"
    sha256 cellar: :any_skip_relocation, ventura:        "fee3be8be93946e1fc41094d503220fe3dca820d76defa3e44be30d099e77fae"
    sha256 cellar: :any_skip_relocation, monterey:       "fee3be8be93946e1fc41094d503220fe3dca820d76defa3e44be30d099e77fae"
    sha256 cellar: :any_skip_relocation, big_sur:        "fee3be8be93946e1fc41094d503220fe3dca820d76defa3e44be30d099e77fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b105adb7599bd6a42f056b7c1a0e0c4cb77e7183fe1e0ff0ea2e79c50b5859a"
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
