class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "3286ad1b324b995fd95818679b4ced80ebc3cc3b4bd4c8e6964695c05c934c8f"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7228814f2f8b8d2c40eb6493a49f2367cd8e6de9d5359a06c16326771979e40c"
    sha256 cellar: :any,                 arm64_ventura:  "8129e5791dc9c0d96330247f140c656c094be4a3d253b22c5c38b40ee3f4699f"
    sha256 cellar: :any,                 arm64_monterey: "4d98f1f9d485eaa9eba6f2072fe0684d8ea5b6e4cb72cd4ae8f61cbca3e5693c"
    sha256 cellar: :any,                 sonoma:         "c6ce5e83cb1bb7d6676281155793d280d4943a43e82eeec0a0d532e55b058425"
    sha256 cellar: :any,                 ventura:        "0b0d806ac97ae7e33f82e9f55c1251702da8d22b7e03e8762d18831a1f3b976c"
    sha256 cellar: :any,                 monterey:       "dea031face1027358e1b5c3a348399585562a1a3826cc4c91a520a8d6f118aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bd05866bbacc29d67c6d2221f38196d8d3f0ed47eae32632c388742100f1fa6a"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

  def install
    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{rpath}
      -DF3D_MACOS_BUNDLE:BOOL=OFF
      -DF3D_PLUGIN_BUILD_ALEMBIC:BOOL=ON
      -DF3D_PLUGIN_BUILD_ASSIMP:BOOL=ON
      -DF3D_PLUGIN_BUILD_OCCT:BOOL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "configuration"
    system "cmake", "--install", "build", "--component", "sdk"
  end

  test do
    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render --geometry-only #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end
