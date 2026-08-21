class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "033845b5d49af3ae60fcc3fe85d82c841d990d3534638a4472123f84b3e82795"
  license "BSD-3-Clause"
  revision 3

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "04810776ae67df0d47db54b06f72bbac2db97e53dd897794f07a80b5e36552de"
    sha256 cellar: :any, arm64_sequoia: "b88be3ae8e39f954500453230bd4da83b29145ae06f9ea7a972061805eb82104"
    sha256 cellar: :any, arm64_sonoma:  "d14d57470cc9fa38892ef71ed9fd1fc87081320307d561e489340ecfb6b14b0a"
    sha256 cellar: :any, sonoma:        "ac7cf4483fcfc5d4356b1fab1ea535f1c45361041190e416ce0c50c6c809e0b5"
    sha256 cellar: :any, arm64_linux:   "26376a44ceb96a85f27c6b33b200a0ca1b38b7d75d2ccd37e569de81c56b2093"
    sha256 cellar: :any, x86_64_linux:  "c1bf2bee831bc117377a070ecf002d9cae957db7cc17fe468e7dc2c05e933427"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "freetype"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
    depends_on "hdf5"
    depends_on "imath"
    depends_on "netcdf"
  end

  on_linux do
    depends_on "libx11"
    depends_on "mesa"
    depends_on "zlib-ng-compat"
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
    assert_match "Camera focal point: 0.5, 0.5, 0", f3d_out
  end
end
