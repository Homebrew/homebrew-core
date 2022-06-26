class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.95/extra-cmake-modules-5.95.0.tar.xz"
  sha256 "ffa02309d92958353e8e7837970e0d038475da5a18074e3442bf6b78ac91ad5a"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "91e0d8e7a058ce87a9e5d0e688b7259ee9047650b07165b6e5ea27fc16c81a72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53069aad1961c4f0ba2d420a8eb64f324b23673e4acdd230f4ee1696c239968e"
    sha256 cellar: :any_skip_relocation, monterey:       "f8882c48d2f3677acd6d1f5b0d6cf42c37bd1f0e39206317e9d8d1fb6ffa988b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8882c48d2f3677acd6d1f5b0d6cf42c37bd1f0e39206317e9d8d1fb6ffa988b"
    sha256 cellar: :any_skip_relocation, catalina:       "f8882c48d2f3677acd6d1f5b0d6cf42c37bd1f0e39206317e9d8d1fb6ffa988b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f308a0f333fa4149325b3269a9d188c75d1605adf69d10539b792f4ec5e91a83"
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
