class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "5b335de78a9f68903d7023d947090d4b36fa15b9e165749906a82153e0f56d05"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f22ecfa24ffe1b117aa267c2effcfa0fe3079c0fefe7aecf8dcf03c4acdac938"
    sha256 cellar: :any,                 arm64_monterey: "692c5513911b98f3fb97814f23543dbc6438446c4d11b5071af4553f61be4da1"
    sha256 cellar: :any,                 arm64_big_sur:  "88e1c26380ed6efb881801cd6147afde1059ed733cac542be74439e24418fdbf"
    sha256 cellar: :any,                 ventura:        "02d9445c9a452ef47c1926cf734589b49c4c50a58c777d827a324d0b4b420f78"
    sha256 cellar: :any,                 monterey:       "012cccb02f44bd7f4e330f57f0f258dae34daf48c786e8144a1e07b3580c806c"
    sha256 cellar: :any,                 big_sur:        "9e3c7624e6d8aad96547a5bca8aa6a87a54aa0ecd1b7cdd930366ee5b2957e20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4934d18b9f5d6cc431efee68761892a984f7ee4822b451cdc0e10ef972deedc6"
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
