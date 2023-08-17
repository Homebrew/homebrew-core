class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.109/extra-cmake-modules-5.109.0.tar.xz"
  sha256 "1526b557cf9718e4d3bf31ff241578178d1ee60bdfb863110c97d43d478b7fb7"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4f8ae41907c7ac67b79617b0dedb7f1ddbde06e9ed9619df0cc60002fa68fe6a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "352037ed52a908e917b34b7995ce438d532cb1bd10c8eca7aad595c73222dfb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4f8ae41907c7ac67b79617b0dedb7f1ddbde06e9ed9619df0cc60002fa68fe6a"
    sha256 cellar: :any_skip_relocation, ventura:        "200994558a02fbc858ca76dc19b18c6fe6432ea4023c38cd96065fd2ab08727b"
    sha256 cellar: :any_skip_relocation, monterey:       "200994558a02fbc858ca76dc19b18c6fe6432ea4023c38cd96065fd2ab08727b"
    sha256 cellar: :any_skip_relocation, big_sur:        "790215a033f5c529deade003ccb6881f459636168ffc80533c394bdb6bc0aeae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89cbc8b8788546647dc4007902735567711883bb4a6b25dc020aefef62f648cf"
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
