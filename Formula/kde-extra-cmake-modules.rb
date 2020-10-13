class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.75/extra-cmake-modules-5.75.0.tar.xz"
  sha256 "878d47a901056d5303bf37414d787046e1d38fac2bd9f2f5ddd00a9dd6b9f4eb"
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "195795d035962b2427418a19ab39d8ffc38d9705c0f1c1503a7002c3fe6f11a9" => :catalina
    sha256 "5f6be7a137c07fd155de462cafded13ecfd76e66df519f4b74256adf9917cf1e" => :mojave
    sha256 "097651b195e96057a039c13a07721ba9342168509eadd0bc1bc270d7ccd74d46" => :high_sierra
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
