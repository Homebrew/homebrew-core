class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.94/extra-cmake-modules-5.94.0.tar.xz"
  sha256 "23548a8ce2b998cfa675fc00112bf93914ee25194f0bfdf832d283c8d678d279"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "802a0f87415d68f5c0dcec97b3082de5b3193c3031304fb272c7be9dc115e42a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "616344072fd6e6307d1eabd739394c999bdd34cb40e07884ed5712f6900095ae"
    sha256 cellar: :any_skip_relocation, monterey:       "ee6f11f1bdeb0f2e998d6e0ae1f36cd170e73e0fd1027488fcfe94ec06fa1656"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee6f11f1bdeb0f2e998d6e0ae1f36cd170e73e0fd1027488fcfe94ec06fa1656"
    sha256 cellar: :any_skip_relocation, catalina:       "ee6f11f1bdeb0f2e998d6e0ae1f36cd170e73e0fd1027488fcfe94ec06fa1656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ae325ff1ba299e5ecdf774c56e7d016b7fa4d7eeb84f68d6253c473a4037069"
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
