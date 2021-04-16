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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62c98704716218b86400a27d692c76a87adfc5f36601ade2f6e30329799d8836"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e426f7010c34f5c6a849b91d2554e40d652d159bac1aeabc6c0dd5c12dc5974"
    sha256 cellar: :any_skip_relocation, catalina:      "219a0b0c84c3bf6a2665397e16f857edca27e38bbebb8d93421a7faf248a4371"
    sha256 cellar: :any_skip_relocation, mojave:        "a60d655c7c7c75aeda3f0739dc17ad2281efbcaf55e093b60ce7ef794ea8c903"
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
