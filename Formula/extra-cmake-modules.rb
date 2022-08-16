class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.97/extra-cmake-modules-5.97.0.tar.xz"
  sha256 "9ed235f3dad82ba67dc61eeab12536b6d5936c036d32d7e7d2f38a17b9efc50a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eeee45abf2c4e00caf90e40f93e2b8573376c3ab97aff1821289efc5ffa00429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eeee45abf2c4e00caf90e40f93e2b8573376c3ab97aff1821289efc5ffa00429"
    sha256 cellar: :any_skip_relocation, monterey:       "eddbd4dff07057210fbf90055817c0f7f6a646861f3c2940209012278c332413"
    sha256 cellar: :any_skip_relocation, big_sur:        "8104634d4dabd20d58f06f7de4e802417ee71a5bfd211090b989962357e9bc7d"
    sha256 cellar: :any_skip_relocation, catalina:       "eddbd4dff07057210fbf90055817c0f7f6a646861f3c2940209012278c332413"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d5a985e62fec77b8271adc38199351dd7e31cc2acb4a7327b090f5be299c99d"
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
