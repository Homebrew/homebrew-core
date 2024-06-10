class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.3/extra-cmake-modules-6.3.0.tar.xz"
  sha256 "1368f8fba95c475a409eff05f78baf49ccd2655889d1e94902bfc886785af818"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "df3b4d8ab55d51c3bbb768773f48e647ebbb2ecb3e5d767d2f3e9966be6bc174"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df3b4d8ab55d51c3bbb768773f48e647ebbb2ecb3e5d767d2f3e9966be6bc174"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df3b4d8ab55d51c3bbb768773f48e647ebbb2ecb3e5d767d2f3e9966be6bc174"
    sha256 cellar: :any_skip_relocation, sonoma:         "0085f25d17142cf4c6d2de7ddac848e6f02358a1aad4060ffc55873bb7702b3d"
    sha256 cellar: :any_skip_relocation, ventura:        "0085f25d17142cf4c6d2de7ddac848e6f02358a1aad4060ffc55873bb7702b3d"
    sha256 cellar: :any_skip_relocation, monterey:       "0085f25d17142cf4c6d2de7ddac848e6f02358a1aad4060ffc55873bb7702b3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df3b4d8ab55d51c3bbb768773f48e647ebbb2ecb3e5d767d2f3e9966be6bc174"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "sphinx-doc" => :build

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
