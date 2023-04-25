class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5b335de78a9f68903d7023d947090d4b36fa15b9e165749906a82153e0f56d05"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a447954a1ff2bfb443080a828c516c904525b56c1880bb3245dc86422d787cb3"
    sha256 cellar: :any,                 arm64_monterey: "7db7bc844612e18b57487981d5e34c9e190d0e7dd34a08deb39ca6634730af92"
    sha256 cellar: :any,                 arm64_big_sur:  "d45e2fbacc28240b02c1387efd673c715d2d43281d6e97ccf5c6d250cdbf5b86"
    sha256 cellar: :any,                 ventura:        "572968e3215ae319245d6bc64c04946a6653ee4150dd44ba5f7dae2c4f458b6a"
    sha256 cellar: :any,                 monterey:       "ab222c40a4e03f59f3694cca5032113e15a99f1e9a277d93c6cdd55c09873773"
    sha256 cellar: :any,                 big_sur:        "d15f5979071c9b0a391665abb79078f29e979f2a8bdf01ebcbd453911c1bcd47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ffc42a929c64005071d87f3455edeb1e802fba134c45d9ef71491935a7c6c600"
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
