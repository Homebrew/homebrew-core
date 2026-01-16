class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.4.1.tar.gz"
  sha256 "a0e17eb352c32aa2f8e7123cf75ec5633d25e230112d4dc2ba2b7024011e2615"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ab1fcf7c6135f914d18f5b36269f9d09193969b09fd949f28dbb1b67760654d2"
    sha256 cellar: :any,                 arm64_sequoia: "485a737141803e91f7d3894cd514f90831e11f193ba6f456a6751b0072d1b2ab"
    sha256 cellar: :any,                 arm64_sonoma:  "672f276647e50eda3088e58da72f3b9dd55a8fd60af99ae67546da13ca27d1b3"
    sha256 cellar: :any,                 sonoma:        "b007b528d5d8cd713d3bc818903e19328ed0aedf30e153346754d0a1ff3248d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b79c1356fb40dc43004426851b57013fdbd5ec5401cfad6294745b03c2968a15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1064ef60e9e1ce648f4e1fb9c21c9328fc2fd97588d21a44131e4e2ba9877632"
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
