class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/extra-cmake-modules-5.79.0.tar.xz"
  sha256 "b29602db99c566d88fa92106abe114bd57b7ffc6ca20773426f896ffde68bed8"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  revision 1
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b037f9a37b5602092d85b8af767ad3f46d970c295aff9bf4b55ca21ecdfd11c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "fc8d6944b8c8900f3fb464cc8f4589bec834d6b7ab9adbce8b380dcf8d7bc00b"
    sha256 cellar: :any_skip_relocation, catalina:      "6461611d4f810ef660c4554eadb4f708fe1f952458d2cd374a8200e36895f1cc"
    sha256 cellar: :any_skip_relocation, mojave:        "daccf07232ea1f687e2f20b0f86823f7ebf421da92f1f4e7608c5197f556ead4"
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
