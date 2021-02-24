class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.79/extra-cmake-modules-5.79.0.tar.xz"
  sha256 "b29602db99c566d88fa92106abe114bd57b7ffc6ca20773426f896ffde68bed8"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6ead5fff1239a71f31c0bf7f19d54b0132f4c67dacedecb13d4abe758e5df1f9"
    sha256 cellar: :any_skip_relocation, big_sur:       "f83bd2fccc4e8bf34dfe94c34f13adebb3dcba9baa1d1b2e8b0b7b66ce688567"
    sha256 cellar: :any_skip_relocation, catalina:      "26b07f9160defd8fccdc26089004aa69a1e6317f5803037523c5815add954216"
    sha256 cellar: :any_skip_relocation, mojave:        "5a87fd54c8bbf969207f49fac0855d768ad061f38cf040080286c70680a9af7b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt" => :build
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
