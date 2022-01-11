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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88981817a313d8f2ceedd1237f00fa04729c3ef8e022fc615649162b0b7194f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d25a15c111e8289715e54f734edaa57267e3e44e1ff40ab065ba1017c9c61281"
    sha256 cellar: :any_skip_relocation, big_sur:        "d54a322b7bce9a92cb0eddafef4247aceaf7680b486079d133c96400d38e29dd"
    sha256 cellar: :any_skip_relocation, catalina:       "d54a322b7bce9a92cb0eddafef4247aceaf7680b486079d133c96400d38e29dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "683ca9b3521dfb0db9b303e71c1303d99465153463f8decbc59544fbaf4f4d2c"
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
