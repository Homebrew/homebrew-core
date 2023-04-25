class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.105/extra-cmake-modules-5.105.0.tar.xz"
  sha256 "59bbf7ae5f8f2a3addb821c6d9962d3d0f0085f3ccd55f18128763d88e31365b"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79ac4d9128f81fdda050f892bdfec5548ec9523d5d479a497cb1e458ba51d587"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79ac4d9128f81fdda050f892bdfec5548ec9523d5d479a497cb1e458ba51d587"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4d65f6b6b40d8c884405dff9c50d0411d9a492e7de741d252ec07fcfc3bc051c"
    sha256 cellar: :any_skip_relocation, ventura:        "79c2b54913d1a6b630ab945501e28e45c1135f9d00314e76fa7659374e8c6125"
    sha256 cellar: :any_skip_relocation, monterey:       "79c2b54913d1a6b630ab945501e28e45c1135f9d00314e76fa7659374e8c6125"
    sha256 cellar: :any_skip_relocation, big_sur:        "79c2b54913d1a6b630ab945501e28e45c1135f9d00314e76fa7659374e8c6125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f832a9072eee6bea1a6c294f3a884b002bf827b3f39268aba54e421f398c9f4b"
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
