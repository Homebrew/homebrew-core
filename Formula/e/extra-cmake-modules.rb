class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/ecm/"
  url "https://download.kde.org/stable/frameworks/6.32/extra-cmake-modules-6.32.0.tar.xz"
  sha256 "305f4e2b82eb073be6ac3e50ace85578b3c0c409be262ccc51d445449e3d9312"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  compatibility_version 1
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://kde.org/announcements/frameworks/#{version.major}/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a6126fbcd14ca68d49b20b6fb0161b988b3d5d720e661cf07c48585dcf4cd8dc"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  deny_network_access!

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    CMAKE
    system "cmake", "-S", ".", "-B", "build"

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"build/CMakeCache.txt").read
  end
end
