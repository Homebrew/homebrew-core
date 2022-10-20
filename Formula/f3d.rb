class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "653dc4044e14d0618c1d947a8ee85d2513e100b3fc24bd6e51830131a13e795d"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1730a7b915a69ef8a9369e7f032511a44bca9d280523cabaa69b2a64faeed122"
    sha256 cellar: :any,                 arm64_big_sur:  "082b489a728ad43f9f80a8aaa3610a2028d3e2eedf8303062973625bd1348fb7"
    sha256 cellar: :any,                 monterey:       "f7f44e7c2c788be7a6ab133c54c1aabdca2fa2aa882f9a8fdc88e8c5bc3f1c7c"
    sha256 cellar: :any,                 big_sur:        "1978912917d63001226f844b18696ac2dee6f79e21f433d4f3c51b8090798920"
    sha256 cellar: :any,                 catalina:       "9f118e2c5e7aeb9a84d2d04ed08fdfd7bdb922abdfd57c0c54409e3ed02e2209"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0deb4bb19364627fd611df0040de1803a623556b27f159e79e3077cf99f53f89"
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
