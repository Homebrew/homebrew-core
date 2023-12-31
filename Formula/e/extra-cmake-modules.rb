class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  stable do
    url "https://download.kde.org/stable/frameworks/5.113/extra-cmake-modules-5.113.0.tar.xz"
    sha256 "265e5440eebeca07351a469e617a4bf35748927bd907b00ace9c018392bb3bc4"
    depends_on "qt@5" => :build
  end

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4995a0fd76465134be635e87d35a9e036c1738b90486042af4cffef14c7e6da4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4995a0fd76465134be635e87d35a9e036c1738b90486042af4cffef14c7e6da4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "602dc769b21b8a0872f35ad87304e353c1cf585f26b4a912d7b3c62aef4f4009"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7ccebfd8b25a0d350e1f9e7f74f265950bf51dc0a1bff5368a145e09919e171"
    sha256 cellar: :any_skip_relocation, ventura:        "b7ccebfd8b25a0d350e1f9e7f74f265950bf51dc0a1bff5368a145e09919e171"
    sha256 cellar: :any_skip_relocation, monterey:       "b7ccebfd8b25a0d350e1f9e7f74f265950bf51dc0a1bff5368a145e09919e171"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8309c356f593a839fff8d5a05b64575c4177b53e655775473bffbf55def6d770"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

  def install
    args = %w[
      -DBUILD_HTML_DOCS=ON
      -DBUILD_MAN_DOCS=ON
      -DBUILD_QTHELP_DOCS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)
      project(test)
      find_package(ECM REQUIRED)
    EOS
    system "cmake", "."

    expected = "ECM_DIR:PATH=#{HOMEBREW_PREFIX}/share/ECM/cmake"
    assert_match expected, (testpath/"CMakeCache.txt").read
  end
end
