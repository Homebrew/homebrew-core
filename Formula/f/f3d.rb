class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v4.0.1.tar.gz"
  sha256 "336dd26581a0a9b0bf9e6e9c900e3f103cf6df58971cfd5bbaf6fa93cd285560"
  license "BSD-3-Clause"
  revision 1

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "2dc597163c84c26e0168b42c43766398249e667eb91a63959e3a04e6ca2756eb"
    sha256 cellar: :any, arm64_golden_gate: "9939e1a95d84353196c33f1e009a3a0b8c6d5d6c518694c4771221ca95cbe485"
    sha256 cellar: :any, arm64_tahoe:       "3f65a8f056b57e9d523c3dba2eda125b0a97b434bd0ea244acc624b01ee09c86"
    sha256 cellar: :any, arm64_sequoia:     "aa9c9c4c87afc834417e0a5719479a7430e336e469da033b2854e31956281d61"
    sha256 cellar: :any, arm64_linux:       "8478423c2341a34a235ca83c64f953fbd2be0a4ae681b452c36aedd816741bd6"
    sha256 cellar: :any, x86_64_linux:      "3a446853b904df77229af9549f7be6c25d21e66a2992808fa37ec0af131b94d7"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

  on_linux do
    depends_on "libpng"
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
    args << "-DCMAKE_SHARED_LINKER_FLAGS=-Wl,-dead_strip_dylibs" if OS.mac?

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
