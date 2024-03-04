class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "9c2906b62f3066f075effbabd6501964391e8a8ffad6ed773c33db12580cc466"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "7b2eeebb01c15b98ed13682042a46950d9eb8385bbff2ba720e61f06fff02c2d"
    sha256 cellar: :any,                 arm64_ventura:  "d356349c3937bffd2c501d1c28155a237edcccfda0f9a276e0405bac46ca5c95"
    sha256 cellar: :any,                 arm64_monterey: "315ff33416549cd2cabdc340026564a794205d8fbfa6311bcac2760b269eed0c"
    sha256 cellar: :any,                 sonoma:         "1b37af2f09f7b22a3ef2c2f57b636af067c339919bf88cb6157a61b41f4c1ac4"
    sha256 cellar: :any,                 ventura:        "46791bc57275ac6c7533318310d1a8ac03b3f14c923120f94945351369f6b99f"
    sha256 cellar: :any,                 monterey:       "41f7ca6226bd7cf16518d19e341d2c043c1887964cdd90d65ef8438c51e701bc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9dbc585d3fcbb441733aa4c09e647cc4284f51fe2dac00adf41687ae226abe3"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

  # Upstream fix for https://github.com/f3d-app/f3d/issues/1087
  patch do
    url "https://github.com/f3d-app/f3d/commit/a5ecb6bd.patch?full_index=1"
    sha256 "62856957da64bdf56243c11573b79a624979d9952f64c613c7fe8d5f0ab484dc"
  end

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
