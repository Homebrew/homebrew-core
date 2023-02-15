class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.103/extra-cmake-modules-5.103.0.tar.xz"
  sha256 "92ca2e55cb38956fbdeaf254231f074647173ccfd12dc9664989c6fa9e9c4346"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a7a922208c449c0d6a9f0a144ac281cd16a96fbe2313d251a234c23faaea05ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a7a922208c449c0d6a9f0a144ac281cd16a96fbe2313d251a234c23faaea05ce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7a922208c449c0d6a9f0a144ac281cd16a96fbe2313d251a234c23faaea05ce"
    sha256 cellar: :any_skip_relocation, ventura:        "f3464d10dd235ec21c2341175b6fd86e8d822c4aa508d7e455a6b781500c7b90"
    sha256 cellar: :any_skip_relocation, monterey:       "f897eb364528670f98adde5dff6a21857896c1e11db8fa01508fdf26b1a24bee"
    sha256 cellar: :any_skip_relocation, big_sur:        "f897eb364528670f98adde5dff6a21857896c1e11db8fa01508fdf26b1a24bee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27a02d81b7784cd55fc340bfbac008f94a387d8c74e7937472c6d8224a4733a7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "qt@5" => :build
  depends_on "sphinx-doc" => :build

  def install
    args = std_cmake_args + %w[
      -S .
      -B build
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", *args
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
