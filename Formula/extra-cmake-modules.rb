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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc58525c99fd405a557f224436ee93d9a4af25ebdca90ed19808ef22ac04a833"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3dc09df8bbe01747619bee4151b3525cd41baad220882e6a03655d516d3f774"
    sha256 cellar: :any_skip_relocation, monterey:       "34be070b8104d18f82db2e3e28e9b8aaca99ed82624c355e8ca7823dafb9eb4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d92125beb1cafb365813037ec7a3f6d0089debebccaa892a044dbc71e7a1ea9"
    sha256 cellar: :any_skip_relocation, catalina:       "7d92125beb1cafb365813037ec7a3f6d0089debebccaa892a044dbc71e7a1ea9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "018b3f8fb6f821978fd7f73ff21e2a19443472f48713a67f6a07a00b01065a4b"
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
