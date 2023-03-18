class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "653dc4044e14d0618c1d947a8ee85d2513e100b3fc24bd6e51830131a13e795d"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1cbcf70cc4bc2f12cf397c61a3126d0142840ed495871b796b2dde3604629b32"
    sha256 cellar: :any,                 arm64_monterey: "741d7927dcc4c2c80f9653fd66fd3715f894fd64c990e6022316ec1252e3585b"
    sha256 cellar: :any,                 arm64_big_sur:  "4792386c6b52c13ad630ef101397722d1f1f71a885c89bbeae3eb4a55aed4046"
    sha256 cellar: :any,                 ventura:        "c285b75a2592d15c0120f7332cf7bc3fee215371b6c7246a7c443293742d8e62"
    sha256 cellar: :any,                 monterey:       "c867f06aa6586641e3a9e6234bffc9ff7d821d2e66be9933b917fdf15619db8c"
    sha256 cellar: :any,                 big_sur:        "d253e69b0bf3d29b5bf0c35c054fd43d7e6ed86539c35dbbd1fd02d76472ed33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ebf32959d3056e6642320ae79d895eff63df6d08d83db056ae82c26ac1740616"
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
