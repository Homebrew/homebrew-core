class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.94/extra-cmake-modules-5.94.0.tar.xz"
  sha256 "23548a8ce2b998cfa675fc00112bf93914ee25194f0bfdf832d283c8d678d279"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d508c7ed3f82bf3cc9fd937993ab6734835a77afbc0454ec0b05e5241a65ce06"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6362e89dbae4e7a10dc1d40419474d2bd12372f5cad441e734678314584c286"
    sha256 cellar: :any_skip_relocation, monterey:       "de9022361ee4e838c5400c06afac3d6f5049a121984c0fb501c40420bcc1774e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27e14c24449f5442418d30cc73dc9f3c47b29889b5ef0aad1c29c518ab8c354"
    sha256 cellar: :any_skip_relocation, catalina:       "de9022361ee4e838c5400c06afac3d6f5049a121984c0fb501c40420bcc1774e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49dd2ded102917a50cdbe05d5c9d10b7c92579edfff15177096fc42cefa9e375"
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
