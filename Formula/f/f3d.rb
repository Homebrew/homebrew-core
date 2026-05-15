class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "033845b5d49af3ae60fcc3fe85d82c841d990d3534638a4472123f84b3e82795"
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
    sha256 cellar: :any,                 arm64_tahoe:   "eeb5b2f7273f15dde1d3e726d4523e579847139166596ec391826de012880162"
    sha256 cellar: :any,                 arm64_sequoia: "d7314f35d07345c492868b06e8ff1c8ba03214f52043240eb78009a00451267d"
    sha256 cellar: :any,                 arm64_sonoma:  "2667009d73c55b825cfec4bb8bddb7fe9c88221437902bb92cae5f069c3b63f2"
    sha256 cellar: :any,                 sonoma:        "eae120fc513b407a8aedcafac540639cc8c8c29ad3e25b442af90dcbfee8b903"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de2ef3187b84b1fb0a1b22706b18be357842b7bfee0fc90e15f67bc97aa1b338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dea7663ca72c6d2e23a79946bc0389f57c088d663b1bb8d491f9e8f2480d7bee"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
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
