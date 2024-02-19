class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "13d33b49bad71a5a1bb9d1ecc927cc2d26d767daebaa6dba145bcc411b8d5f27"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0113fc68c1e3c7453a98132babcea676a6abec364542df091f00639ba44a89ef"
    sha256 cellar: :any,                 arm64_ventura:  "9a66a46734eb9361aadc05d8216cb3c8f716447b3a3a4953cbff90102045b638"
    sha256 cellar: :any,                 arm64_monterey: "269d23f4d5f704263e6d1efb5dc382c5ce90d8d1ccd786e66ce7a41ba6233fdf"
    sha256 cellar: :any,                 sonoma:         "31a270d34501fb0dda0abb9e7c2975d2263efcddfcc6ea78426dc2b51b23f076"
    sha256 cellar: :any,                 ventura:        "db5e0726a802d823dd9aed33a657b8f22c9a3365576b1a46ec631304786fb9b3"
    sha256 cellar: :any,                 monterey:       "1cb253a47d469d629dc9354435ca77d9032b30f43bb6c0da221803987f29b3bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a6a083a83f23b1b577959f6ce54569190219c00834aa6abcc56d46dd3e934ba"
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
