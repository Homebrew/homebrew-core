class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "9c2906b62f3066f075effbabd6501964391e8a8ffad6ed773c33db12580cc466"
  license "BSD-3-Clause"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bcad7d34043370b81a4cdf53644e13f376f4dbe7d6c069c7f670802b7271a298"
    sha256 cellar: :any,                 arm64_ventura:  "1a3016b4fa3720db4107415e74d8fcb84844c438499262b9a6a7e85bcd68c313"
    sha256 cellar: :any,                 arm64_monterey: "0971955926faf47a8b75d91c7e0318ae0a4f381f12aee9004fdb67d7b4c65421"
    sha256 cellar: :any,                 sonoma:         "d97c18e472b1d4feca5b6b56cb87e91d420ce19fd5eb13374f9d3d820d4cb66e"
    sha256 cellar: :any,                 ventura:        "117b6f726dbfd5f030c41eb1e04e4c2f0c064cacbe69c47b1a8989124ecface8"
    sha256 cellar: :any,                 monterey:       "2edb856024a3b602b58f06ff0b9c2dfffd4fe11b8c0e1a9cbf6affcc4bf19b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cc33156b2695e74b4fdc75fe8a20a49b01d47f15921c12c5f854d979337425f"
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
