class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "4d3a73b0107c8db7f0556107c74087d3748232a73981f65f7c5186ac1003ec8d"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4de29c35c78dd8c5f96daf9a9f8206940941fb88f59a70f54487c6c4cb024069"
    sha256 cellar: :any,                 arm64_ventura:  "9fb7443035a5ea68c26dd074b0be847f8e1c50549eb934d876ef2d7a7dfc23bc"
    sha256 cellar: :any,                 arm64_monterey: "d79866a65f5b726524d85a142301504c10c59508d6f7c1829bac182456252bdf"
    sha256 cellar: :any,                 sonoma:         "60a3757a5e5f2201b73725ee3d1e1e8edde7ee397a8f9ecf62d5c9bc2910bced"
    sha256 cellar: :any,                 ventura:        "b2e299bee42acf697722fb5b78725a6b05b985056ee3c160002bda826842875b"
    sha256 cellar: :any,                 monterey:       "58c2c2c044752c5d950d783ee78fb3b3ed5f855fc58076052af47c5a27965adc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a41d9f975040dafafb30e6237ba8227ebe334f32ed01eb30449f4ad038f46249"
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
