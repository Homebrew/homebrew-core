class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "653dc4044e14d0618c1d947a8ee85d2513e100b3fc24bd6e51830131a13e795d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "eb43ad624a8cda6e60911b4de70631e5cfa71c7bc0ce2260337f1442243060f7"
    sha256 cellar: :any,                 arm64_big_sur:  "267fcff261a954ec13a7cd01f59f4db0dbf01215e7df0404121edd9e88cae7c9"
    sha256 cellar: :any,                 monterey:       "7e8cb99a85f499057447134306a1fc80d2a7d7a74f1dd58faa3ed633afcb90aa"
    sha256 cellar: :any,                 big_sur:        "90819e0682f31fb0df1b634b0554d6cf672a37d0d2b06c0218f1d0c786565fdf"
    sha256 cellar: :any,                 catalina:       "9ef83d637737e119fefc46f957d43c8d22c1e3a9fed97985919e6a7bad2da58e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15009a2d7db2bb5e73156a0aa5f24a0b13239791ea47591113d4b57af5e44158"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

  def install
    args = %W[
      -DF3D_MACOS_BUNDLE:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DF3D_INSTALL_DEFAULT_CONFIGURATION_FILE:BOOL=ON
      -DF3D_MODULE_ALEMBIC:BOOL=ON
      -DF3D_MODULE_ASSIMP:BOOL=ON
      -DF3D_MODULE_OCCT:BOOL=ON
      -DCMAKE_INSTALL_RPATH:STRING=#{rpath}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
