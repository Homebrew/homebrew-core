class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "a0e17eb352c32aa2f8e7123cf75ec5633d25e230112d4dc2ba2b7024011e2615"
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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "932e823218e860da4df03979774137bbf8bcb0e6af3eeedc49b258a5c95cdea7"
    sha256 cellar: :any,                 arm64_sequoia: "241a838de1fc94e9ac0b41ed03a3740f2eea2351a3a5eea62c9bb60b468781f0"
    sha256 cellar: :any,                 arm64_sonoma:  "c459ee84b067a309e9e5a4036910990f3fa8002245d447ba0ebf5bde37f222a5"
    sha256 cellar: :any,                 sonoma:        "ec6d5c537ff25dfd3e55b5db28ca0b1b523bd8bf836950c42b382f2a5e452bfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "666a640c9aa10f5ba3f2900780ee8e17f6339fe8012febdc2cc2b602a8853ebb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e94147ecb681078ef6ae85697378809065f2778a2902ecc50c809ba4d4a23c63"
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
