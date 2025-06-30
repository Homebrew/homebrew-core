class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "93ba23078133122e929d9c1e2946c86da1f08fe56b9ffae40ebfd8185e91380a"
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
    sha256 cellar: :any,                 arm64_sonoma:  "4fbdb80d0a0fced279e3125ebfca0b0365c0855ba391098fdb79a1047ac3da12"
    sha256 cellar: :any,                 arm64_ventura: "0f026b208a2584cb5ddce7166e2fa1dc41ace112e9f1636f9cf93f3da465bd49"
    sha256 cellar: :any,                 sonoma:        "9b4d9d512c52ef679af9c47a47b43518744d6713095a39d38f8eb57efef05b4a"
    sha256 cellar: :any,                 ventura:       "259f9de6738a739a0b871db3af4e655a0060df368b487ea9f02d331d82f3e9df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d8544f5f7c2f9675f70a6e05db9c9f5017cba9113ff7f813519350749bdd8dbe"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp@5"
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
