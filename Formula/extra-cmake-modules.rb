class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.88/extra-cmake-modules-5.88.0.tar.xz"
  sha256 "33bd83908daa531654455b77fc121b598f757aadf8ba01dbacfda8b8fb050319"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cf4de12510eb615ee6e8ce97ac59bba40f0873261078d6d04f5b161ad4791f1f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2eab1e9fd47e8aa48325af480fa3856dd5975f5be7e1dd6f75c19957c60c0389"
    sha256 cellar: :any_skip_relocation, big_sur:        "31352f09fa1bf711fb774282af228c3c987ef339bca2b9a9ab4fb3f18e1a4e47"
    sha256 cellar: :any_skip_relocation, catalina:       "31352f09fa1bf711fb774282af228c3c987ef339bca2b9a9ab4fb3f18e1a4e47"
    sha256 cellar: :any_skip_relocation, mojave:         "10a0b4c4c07c800667be9acebd43250c6aad8f21442ecb351079d44f3e791503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46c206ec9f6d8b8ec59d00836cb2104c886fdf289550dd1c00e1ac30742840c7"
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

    system "cmake", "-S", ".", "-B", "build", *args
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
