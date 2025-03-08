class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "7ea83830d1c8158a1f01e5ac9edd00b81de3e0b4cbdbc4a4bb60a113728b7b7a"
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
    sha256 cellar: :any,                 arm64_sonoma:  "ffbf0f6ac3a37b4faa55b40fd196797f92342befd3a4ee3d49c7f9d59c9852a8"
    sha256 cellar: :any,                 arm64_ventura: "1fc93ec85c18df89287c1d948daba3fee76973e799e380e02c1e967723334fc4"
    sha256 cellar: :any,                 sonoma:        "5598f6f0e370687d7e7f9adb4a840bf8e247880d2e1048872657ff01025e3062"
    sha256 cellar: :any,                 ventura:       "132be0e3de68997940a1303e649bd7af9f4c234ca28d4f9064659766e5a9f5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af26dc1212799218a0fcdb6c0a5b5e26ca640e514f6035d4b4fa8c69cd60a200"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "jsoncpp"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
    depends_on "freeimage"
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
    assert_match "Camera focal point: 0.5,0.5,0", f3d_out
  end
end
