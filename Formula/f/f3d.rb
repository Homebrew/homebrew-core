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
    sha256 cellar: :any,                 arm64_tahoe:   "e58d08ba2e875ee32ab0b4a877e4a64053992d8d2894ee7a4347e6821b19cf8c"
    sha256 cellar: :any,                 arm64_sequoia: "ec2e4338a8ba9a0c3b6096e9970d899090dca394b116c9e4cf89398ba506fc73"
    sha256 cellar: :any,                 arm64_sonoma:  "af3061e49d8e2725e876dcb8afb13c1aa7e993da6ecfcd618145afc443a8a1d0"
    sha256 cellar: :any,                 sonoma:        "861f9f6a3014f48da4a1bccdba2b3bd8c604981bc927557e88f603a2c33e19aa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8acd751bcbdadd98e11838e9d409a99662968c72dab8b70a72d683d24651ec3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9d911e78c247be54f60ba44e697abc5f0a71259b95052de756a62f751899dc26"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  uses_from_macos "zlib"

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
