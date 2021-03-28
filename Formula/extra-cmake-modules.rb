class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.80/extra-cmake-modules-5.80.0.tar.xz"
  sha256 "2370fd80f685533d0b96efa6fa443ceea68e0ceba4e8a9d7c151d297b1c96f64"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "73af52ca8f90dc4a66c543ed896d97cf7820fc016e486d1f9a05d3f662883959"
    sha256 cellar: :any_skip_relocation, big_sur:       "3b53cf2a416928afe6bf92bce808a6816ab7c9e8fa08f1c9b7efeb74be7647e8"
    sha256 cellar: :any_skip_relocation, catalina:      "63f12faa74b40544530ca7a674de660fd545b746a8ee0a215649abe1cf43985b"
    sha256 cellar: :any_skip_relocation, mojave:        "a4c91e88ecd0abc7875bc3fcfaaf8680503f49b327a5bef11354e96fb24a6cc2"
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
