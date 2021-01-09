class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.78/extra-cmake-modules-5.78.0.tar.xz"
  sha256 "eede1f0c21f24eca56bd71a805fa76500a8c683bf21982cb33f4bba682d012f9"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "ddb3aa8fc133d2cb3bbb59945639205dd13b1b753b3a3cd987ace33e3334e5bd" => :big_sur
    sha256 "f6d3546b322052f93272ce60d45ea5ed7cd418239223fceb5dfe6d012c021671" => :arm64_big_sur
    sha256 "bb0655a32826cb4d2d973dacd758130c59ca4a012930630d87605f49be634c6c" => :catalina
    sha256 "8eaa93ae5208af856982385e97a31b41f206d6e1d74de9b11de9dd8ff874516b" => :mojave
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
