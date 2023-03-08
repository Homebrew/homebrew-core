class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.3.1.tar.gz"
  sha256 "653dc4044e14d0618c1d947a8ee85d2513e100b3fc24bd6e51830131a13e795d"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d19122637681362a34a7db04dc5c917443abd922da557c331e08bffde44eb53b"
    sha256 cellar: :any,                 arm64_monterey: "48c6f6abfdd27c4875700d1fd2757584b403b6331779c33c920368e2548955db"
    sha256 cellar: :any,                 arm64_big_sur:  "56d65f127c9f07fdf97e16274fa4d5791e0a4eba2fb081782c33d0c543d9ee4e"
    sha256 cellar: :any,                 ventura:        "7054aea63ff751b2016baaaa428c611032baea30435734a55367c417c5b3f26a"
    sha256 cellar: :any,                 monterey:       "826621baec0a247fba7f3ddf538a721c6ffdf020c4499123826bb14d334c5d0c"
    sha256 cellar: :any,                 big_sur:        "84e2e87aac1a56644722f7bd124053031d4af5be83fc18ae0bd59c1cc20ed60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c94ad1c1963051e2a991710c43b07811b3a4a450d81a7d4384a76b39e7eb3286"
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
