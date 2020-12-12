class KdeExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.77/extra-cmake-modules-5.77.0.tar.xz"
  sha256 "42f071f628b192122894026de20097cb0b3de411cb41c6935b48eb86ce992a65"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "926139da0a3290e13d5c74b640e45c733363cedbdf40b8880b8ff299daa3decf" => :big_sur
    sha256 "2e9c3f233344befa54596d1c0627a57750da4ffe9dea24235bd72301e05024a1" => :catalina
    sha256 "73e95fc0b80b2f8e11d7e1a06e51b521d088cf3b549ff343cd42fd833a4ef762" => :mojave
    sha256 "068abe8b3d6c188c7f7b66c4ef14b1c6a34772a0555b373dfce4fea3fee76b25" => :high_sierra
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
