class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d.app"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "f3feeaed716022bc3440b891afbd5eba82a69af7215f66bb9aa72344d7591126"
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
    sha256 cellar: :any,                 arm64_tahoe:   "8eb787108d303c3033c7a510258d563ecd9c4b642961efa2f3d88c88b111bbd3"
    sha256 cellar: :any,                 arm64_sequoia: "4908e5598772ab394a6938a4d88e9de9ffee3e5f2823af7b4ab87ead2bda6603"
    sha256 cellar: :any,                 arm64_sonoma:  "c122044a098c39371c89e084346a4130d4ebb2a4bbf45e0db89d210463ca151f"
    sha256 cellar: :any,                 sonoma:        "a79c9ba5de27b819ee64817e0ca7c00a7faf6b32f043a42993260ccd659d1c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ca5be6aeb941e0c2b32421dff594d0acd3509ad82c89308b8ca34c4918b78e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1256bdcbd5bf67be81f0ffef8ac510a3ae41e15a34de960f2f40e69c648ad19"
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
