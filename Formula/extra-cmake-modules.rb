class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.104/extra-cmake-modules-5.104.0.tar.xz"
  sha256 "e49eb21fdb66634b84cccbf6ba65eae3f8e0eee0dc72d50f627280f49df585d9"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dd3aa26ac2f76aff461632c92dc85c6618cebec1fc29e549be7e62a59d9af47e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd3aa26ac2f76aff461632c92dc85c6618cebec1fc29e549be7e62a59d9af47e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd3aa26ac2f76aff461632c92dc85c6618cebec1fc29e549be7e62a59d9af47e"
    sha256 cellar: :any_skip_relocation, ventura:        "460ba0525663aaec788cd201e729b85d64ba05ff6376182e43843a0902512679"
    sha256 cellar: :any_skip_relocation, monterey:       "460ba0525663aaec788cd201e729b85d64ba05ff6376182e43843a0902512679"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f7f47470bcfe1f31148355b3a360d5ef59200250f24a414a7831c24dfe236ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb052c2016d1ef81f84dc86c26ae7b8e30d3f9809b898381b0b1c7efc2610705"
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
