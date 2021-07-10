class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.84/extra-cmake-modules-5.84.0.tar.xz"
  sha256 "bb085ef2e177c182ff46988516b6b31849d1497beb2ff5301165ad2ba12a1c41"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "422cd402d113793935be4647aec5a8f297a320cc61c3ae716a025de99c5a681f"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b1fd6d8d4bece39f3624eddecf2722a1e3cb7e3b7c7c7af8b015345bd3038bf"
    sha256 cellar: :any_skip_relocation, catalina:      "3b1fd6d8d4bece39f3624eddecf2722a1e3cb7e3b7c7c7af8b015345bd3038bf"
    sha256 cellar: :any_skip_relocation, mojave:        "3b1fd6d8d4bece39f3624eddecf2722a1e3cb7e3b7c7c7af8b015345bd3038bf"
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
