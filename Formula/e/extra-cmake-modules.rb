class ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://api.kde.org/frameworks/extra-cmake-modules/html/index.html"
  url "https://download.kde.org/stable/frameworks/6.1/extra-cmake-modules-6.1.0.tar.xz"
  sha256 "76c9edf00807e6cf8d4ae35f5195b4bc3fe94648d976fef532bf7f97d86388bd"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "MIT"]
  head "https://invent.kde.org/frameworks/extra-cmake-modules.git", branch: "master"

  livecheck do
    url "https://download.kde.org/stable/frameworks/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "eb39f06cc5e01aed45c8214f6106c54226bf9fa1132bdc000bf656a422c01822"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb39f06cc5e01aed45c8214f6106c54226bf9fa1132bdc000bf656a422c01822"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eb39f06cc5e01aed45c8214f6106c54226bf9fa1132bdc000bf656a422c01822"
    sha256 cellar: :any_skip_relocation, sonoma:         "ef28b4c2e2f8ea787b934f2d2b71caacb407c4136250020b148cd0d32e751ea6"
    sha256 cellar: :any_skip_relocation, ventura:        "ef28b4c2e2f8ea787b934f2d2b71caacb407c4136250020b148cd0d32e751ea6"
    sha256 cellar: :any_skip_relocation, monterey:       "ef28b4c2e2f8ea787b934f2d2b71caacb407c4136250020b148cd0d32e751ea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb39f06cc5e01aed45c8214f6106c54226bf9fa1132bdc000bf656a422c01822"
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
