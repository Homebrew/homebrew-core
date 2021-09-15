class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.86/extra-cmake-modules-5.86.0.tar.xz"
  sha256 "aacc5ccdc5799efe34e2dae33418c379466caf7c9802b78348ccfb5782fe6ab5"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0390fd3a6468ffb7eda9285c6ac330ca917e17dbfd20b0bc766fe228be98db9b"
    sha256 cellar: :any_skip_relocation, big_sur:       "91846951ef36fafffa1260b280809d255dca77ef12eefdb6ac1fb44533591a16"
    sha256 cellar: :any_skip_relocation, catalina:      "7dfe71bd0d8566568c661bcb5a04a91cba08e123c7dbc543c3cd2990fb942170"
    sha256 cellar: :any_skip_relocation, mojave:        "7dfe71bd0d8566568c661bcb5a04a91cba08e123c7dbc543c3cd2990fb942170"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ccd6f7dbc0abe72ce36b7ebef90a239febf3827e65c8ac2489dfc04e30c30e0d"
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
