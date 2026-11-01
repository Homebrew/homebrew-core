class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "336dd26581a0a9b0bf9e6e9c900e3f103cf6df58971cfd5bbaf6fa93cd285560"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "be405efb260d3cd95103bb2e39a22c6a96c58f033eeeaeb308559c1458f09c36"
    sha256 cellar: :any, arm64_tahoe:       "09316bcfe83d002c3304b4c5bd7044af3245d0f3e2a4959552161e41f7c37f8c"
    sha256 cellar: :any, arm64_sequoia:     "c9a9e3332fe5ec88eb00212d0a2a629d3ae619724c2253b1c95c07e46558549e"
    sha256 cellar: :any, arm64_linux:       "a6f26b53fff064fc7361eebc5c27f8fa34f7afd86cb40fc96692c08ed1b79d5e"
    sha256 cellar: :any, x86_64_linux:      "47c4b9d1441d1734cfbcbccbef394cb38542ed334c423117a61cb924f12b84ad"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "freetype"
  depends_on "libpng"
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

  deny_network_access!

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
