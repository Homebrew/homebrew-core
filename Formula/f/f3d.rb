class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2a3cff123821be41d99489e080a7153812e58a86598fa9f4988099660bf6a947"
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
    sha256 cellar: :any,                 arm64_sonoma:  "e8cde110e73ff4b121306655cde089070450c72f336da36086a64e306833c489"
    sha256 cellar: :any,                 arm64_ventura: "aad1d07372463a276187a1d69543455fc332226a73033d9120e4e526ec7894ee"
    sha256 cellar: :any,                 sonoma:        "89dc06e6cf2205f7e0a1f96b7100b5085b545e1fa06cf9c4cb03768003b19c31"
    sha256 cellar: :any,                 ventura:       "8dfdfd3d3e73724107614f5215b88e709eee237f0de276c5dbfe59585836bfa7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae4d13eb52f13a44859006028e2bf5106e6c7de169cdca40c5db45be99a076fc"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  uses_from_macos "zlib"

  on_macos do
    depends_on "freeimage"
    depends_on "freetype"
    depends_on "glew"
    depends_on "hdf5"
    depends_on "imath"
    depends_on "libaec"
    depends_on "netcdf"
    depends_on "tbb"
    depends_on "tcl-tk@8"
    depends_on "zstd"
  end

  on_linux do
    depends_on "libx11"
    depends_on "mesa"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DF3D_MACOS_BUNDLE=OFF
      -DF3D_PLUGIN_BUILD_ALEMBIC=ON
      -DF3D_PLUGIN_BUILD_ASSIMP=ON
      -DF3D_PLUGIN_BUILD_OCCT=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "configuration"
    system "cmake", "--install", "build", "--component", "sdk"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/f3d --version")

    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading files:.+\n.+obj/, f3d_out)
    assert_match "Camera focal point: 0.5,0.5,0", f3d_out
  end
end
