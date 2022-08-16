class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.97/extra-cmake-modules-5.97.0.tar.xz"
  sha256 "9ed235f3dad82ba67dc61eeab12536b6d5936c036d32d7e7d2f38a17b9efc50a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e21d9ccf1b497cf4f18cff4f53382d259c656e6ef9265d841647bb993a8c66a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4e43dbf1c1f051195396ceac755a853adca88f91ffdd0970b986e2a565fec93d"
    sha256 cellar: :any_skip_relocation, monterey:       "87e1f1f4cf996234a7c4c82638c77707a8dc0527a947e47a971aa4af4fec3c28"
    sha256 cellar: :any_skip_relocation, big_sur:        "3fc859d4178ec6485f11f8c83c00be2c86dca2b3072b4203cf78d9c070bd3375"
    sha256 cellar: :any_skip_relocation, catalina:       "3fc859d4178ec6485f11f8c83c00be2c86dca2b3072b4203cf78d9c070bd3375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c6c50985e6a84557702b0e04dfcfd42a5ec4b70eae62ec4798cea1c138e948"
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
