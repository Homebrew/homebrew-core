class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.72/extra-cmake-modules-5.72.0.tar.xz"
  sha256 "077af496e208722365f095da59e02382b66f7498352c8666e903603062657940"
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e6fd8d26ecc86d032459031b2216c8d7f6f9cab439082d83bc8a2c45c16207ad" => :catalina
    sha256 "1be9e7b07aa5287cf1aad620e68fb4d3a751eaa745e486df7583ae906ac1fbe5" => :mojave
    sha256 "1be9e7b07aa5287cf1aad620e68fb4d3a751eaa745e486df7583ae906ac1fbe5" => :high_sierra
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
