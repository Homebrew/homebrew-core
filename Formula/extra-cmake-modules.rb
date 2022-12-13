class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.101/extra-cmake-modules-5.101.0.tar.xz"
  sha256 "8c4c561310db587d390a6c84afc97e1addbaddd73b9d7a4c7309c5da9b9bc8f2"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5d8cda941a1260c80ec83c9b02ee7b397dcc84dbcd5bb89fde22f00313a495a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5d8cda941a1260c80ec83c9b02ee7b397dcc84dbcd5bb89fde22f00313a495a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f770b6be4916899607db73d90ae3509d4293edb8257f2ce875874b8e5e2e1dcb"
    sha256 cellar: :any_skip_relocation, ventura:        "b7ede559b811c751e56f3b4bfad198aaaf02decb9cb5fad6add136e254415de8"
    sha256 cellar: :any_skip_relocation, monterey:       "f5940f687ed0b94585c8737c417b9137d12b2510e29fae5d76389acbf581c96c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7ede559b811c751e56f3b4bfad198aaaf02decb9cb5fad6add136e254415de8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6bd6a274c4d56d2b10bcf381d5659a6c2a3fb372fc6b4221363df9b06957ad9"
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
