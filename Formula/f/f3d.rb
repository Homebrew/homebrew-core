class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "033845b5d49af3ae60fcc3fe85d82c841d990d3534638a4472123f84b3e82795"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e0b479b9c99b5b35fff79d947303be2e4a869271676daaea1597f02b9ad9db0f"
    sha256 cellar: :any,                 arm64_sequoia: "84940bd5f8b7a62d23971ebd7e7d219afe2ec956ed346fef43f703ac8162ad9c"
    sha256 cellar: :any,                 arm64_sonoma:  "e1f620233e01e71273e71693d6fd0314c71c46f78e0429de836959a74b5d0c21"
    sha256 cellar: :any,                 sonoma:        "47c59b7ee8d6eacf217bbd23efbeb42344779c3a5feae1f32d3cb964f5e5ce75"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c70b3263d8032a13c5c5fd19d7935d336b7d6f7f0c59772d8bcdf2fe3b3ae272"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d3cd5930190c1a6f2848ba21e9220978a5e6679c73e93f3f9cb1ff6d6a3e8d3"
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
