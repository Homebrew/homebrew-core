class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/5.110/extra-cmake-modules-5.110.0.tar.xz"
  sha256 "7746f5db3e230ee2485e603580cc4c7cec636c3258c0a909766fb281913f6438"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  # We check the tags from the `head` repository because the latest stable
  # version doesn't seem to be easily available elsewhere.
  livecheck do
    url :head
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "34b9c5a5ace9f33d6ee11298ded4b640bb6cdaada32606d45110fbe0186bbcf1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb19ef476e752f161136bf16e6c76cedb8485c7fa9739460a46d79f4958fa7a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb19ef476e752f161136bf16e6c76cedb8485c7fa9739460a46d79f4958fa7a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eb19ef476e752f161136bf16e6c76cedb8485c7fa9739460a46d79f4958fa7a7"
    sha256 cellar: :any_skip_relocation, sonoma:         "03c286be2e2d84ffaf9bb38736f22d8537908c524675b89284e6e265a0ac0b79"
    sha256 cellar: :any_skip_relocation, ventura:        "526590d143139c6f547b2cc461101c84c98846785b4c0c2bada5c72cfccd4e4e"
    sha256 cellar: :any_skip_relocation, monterey:       "9590956f8cb83f71d49f443dc87814f5da6306ea33cec6b4d28be663948ddc99"
    sha256 cellar: :any_skip_relocation, big_sur:        "9590956f8cb83f71d49f443dc87814f5da6306ea33cec6b4d28be663948ddc99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b7f5903aca4461a33dcc466e7e4e2e0da7b82dc453fd63c977b90b87b3fc9e4"
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
