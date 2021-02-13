class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.78/extra-cmake-modules-5.78.0.tar.xz"
  sha256 "eede1f0c21f24eca56bd71a805fa76500a8c683bf21982cb33f4bba682d012f9"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ad78be49a63a55f83e6351db2000980ad1addfef434ebc025b1d753db688e31c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4dbad4835c3abd9e784d2525f3490e0c600faf36d5b4ff71bd1020d618add8b"
    sha256 cellar: :any_skip_relocation, catalina:      "0959c61b9dd8310b4f20011b6fcb94ef75e7106549d4790596834cf8a45662e5"
    sha256 cellar: :any_skip_relocation, mojave:        "157fffc317070515531225c93ec0b1a0c598cdf1155924f578b6925f46d5de41"
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
