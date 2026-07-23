class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.5.0.tar.gz"
  sha256 "033845b5d49af3ae60fcc3fe85d82c841d990d3534638a4472123f84b3e82795"
  license "BSD-3-Clause"
  revision 2

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2355894746eb1ea5b18f5944ea09fb6a5cc33295a0c2401bca5a6e92890153f2"
    sha256 cellar: :any,                 arm64_sequoia: "bfa9fbf715b40d88ac02de0597be5a6048d723ad6e6171e546d79b0b6acf6be6"
    sha256 cellar: :any,                 arm64_sonoma:  "782c075b1f292869c35cd672c77479d397a206241aeca6d2742fc96416359468"
    sha256 cellar: :any,                 sonoma:        "eaa1c0a8ad18e38d3cc056d28381c986bbed34d1eac3c810bea1ee7e05fa5c94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24ee295cdd7f263103cd9cefb6c2261e87ea18294c934aa155d8f75d3fe834cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "070bca57f87dade19b402cc8b5a3dfb06b4b418fcdf8230e2e3ba4730b287798"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
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
