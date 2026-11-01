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
    sha256 cellar: :any, arm64_golden_gate: "51f6fc52c5ab7739ecf9bcbfc7f7bf70465e5ec063972e3a1bfad5352f649247"
    sha256 cellar: :any, arm64_tahoe:       "c09341f605298fc9d37c5a8e4e9150ddd5aae71d7e6913bb315e67acabf374d7"
    sha256 cellar: :any, arm64_sequoia:     "a637e5e2eb8a54a3500851d51cea00ff4599b890b8740c2b37b19c91f48cc396"
    sha256 cellar: :any, arm64_linux:       "1fd021c532aa50503da1de7a376d9d209c845877bca67096413852f9724bec59"
    sha256 cellar: :any, x86_64_linux:      "44b41fa1c999dfc9979a93f3eaf193932d33b0a80fd82ff1ff2191b95e6b23c4"
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
