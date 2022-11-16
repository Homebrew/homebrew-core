class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.100/extra-cmake-modules-5.100.0.tar.xz"
  sha256 "34563ce7bbe3c4d8f69ce1f5dc87ae052443a6b0349fefb9e244a7358b16c0c5"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c71a62bd7ad470f5fb28a1dfa851059036fa4336a81f36509084d10b1eb0b90d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c71a62bd7ad470f5fb28a1dfa851059036fa4336a81f36509084d10b1eb0b90d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a586715c3ab230884f2e07166d9f5cc7fe560a38cf47a77572180b270925ae8"
    sha256 cellar: :any_skip_relocation, ventura:        "50d3147e5ada259ff73b9ad0b7365542a1e2b37c6077b9e964ac80c929b8bb33"
    sha256 cellar: :any_skip_relocation, monterey:       "158f7f0598bd73392f0239a138548d5590e95d462703837fe8cdd86536810ede"
    sha256 cellar: :any_skip_relocation, big_sur:        "158f7f0598bd73392f0239a138548d5590e95d462703837fe8cdd86536810ede"
    sha256 cellar: :any_skip_relocation, catalina:       "158f7f0598bd73392f0239a138548d5590e95d462703837fe8cdd86536810ede"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b048bbef057bcc5cb67c768d0b823916e33cb8c512ace8e179c10ae6d571764"
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
