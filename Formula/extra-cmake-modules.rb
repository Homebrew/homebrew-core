class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.106/extra-cmake-modules-5.106.0.tar.xz"
  sha256 "404f58ecac5d37485e51472ff5f88149f460689bec8792ea29bae279e63cb598"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "edf00ddfc43daca68624c5c112946699f236516b46529600bbc96ed7538429df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "edf00ddfc43daca68624c5c112946699f236516b46529600bbc96ed7538429df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "edf00ddfc43daca68624c5c112946699f236516b46529600bbc96ed7538429df"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a3597c408ba48862820926b5ecb5d0691e02e3ef7c7da7a4f7b0937dd90d51"
    sha256 cellar: :any_skip_relocation, monterey:       "d7a3597c408ba48862820926b5ecb5d0691e02e3ef7c7da7a4f7b0937dd90d51"
    sha256 cellar: :any_skip_relocation, big_sur:        "d7a3597c408ba48862820926b5ecb5d0691e02e3ef7c7da7a4f7b0937dd90d51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ee3218ad6709e1529b6ca85cbc3b4d61119088b546d05975d00f86fe0b360df"
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
