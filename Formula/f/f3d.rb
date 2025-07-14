class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "2a3cff123821be41d99489e080a7153812e58a86598fa9f4988099660bf6a947"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "b4d6c998da4b4400ec393db77b1179bff8d831da62ec0bc14f2dcbf3b148092e"
    sha256 cellar: :any,                 arm64_ventura: "19fb79db099dfa5bec63e662356608de158a8b81aa6e16b885e857d46a4598f8"
    sha256 cellar: :any,                 sonoma:        "25ba5dbee1df01d8c1e76b0ca7d2df0fc94d194ae222200f5093ac80533556ee"
    sha256 cellar: :any,                 ventura:       "2ac0379fa03532632b72f2d09589f8b73986ffee89f3eb3f2eabb1e6d369b46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7d3ce5e14c08f8b86b7ac555d8a0307cf3e9c0d5d90eeff4167ae2d3ddfcb25"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp@5"
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
