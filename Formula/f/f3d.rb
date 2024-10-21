class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d7f6dd7d9e4465c1f44d168c3a38aad24569a25907673180c8791a783e73f02f"
  license "BSD-3-Clause"
  revision 2

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "1a68d410824cc006cd3cf9680be8a666866a0545aa584315b87c479cd1e97603"
    sha256 cellar: :any,                 arm64_ventura: "e3146c04da9452ce86f5a3a760b8decc7d860cd82789f1705a9d002e6f79ac90"
    sha256 cellar: :any,                 sonoma:        "9951f6caaee5baf1acc8af3611f56145323ed2b052bd5fe61f5c1e877e1a0b31"
    sha256 cellar: :any,                 ventura:       "2af6df34acb758afab52877b765bcfaf423c7a7b98978b9aed3f457a50963262"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e163716cc6d6fab4e93e10e718791b2eb3c653ce0cbbd42d18e07d1eefa3cb89"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
    depends_on "freeimage"
    depends_on "freetype"
    depends_on "glew"
    depends_on "hdf5"
    depends_on "imath"
    depends_on "libaec"
    depends_on "netcdf"
    depends_on "tbb"
    depends_on "tcl-tk"
    depends_on "zstd"
  end

  on_linux do
    depends_on "mesa"
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
