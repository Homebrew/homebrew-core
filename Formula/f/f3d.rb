class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "d7f6dd7d9e4465c1f44d168c3a38aad24569a25907673180c8791a783e73f02f"
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
    sha256 cellar: :any,                 arm64_sonoma:   "d1cc7c01b332499f0b6029d00fbd941afeb9b1b8b4cdd63848ac8bc80da9eeeb"
    sha256 cellar: :any,                 arm64_ventura:  "5ab0589087f07df3fc947d4f94e2f234d8926a1ec9f75ab021911ed28d76f20d"
    sha256 cellar: :any,                 arm64_monterey: "e56500ca09cd442367725ab5d4a0ae4c22eafb18572886aeddb806ee4f2b2bbc"
    sha256 cellar: :any,                 sonoma:         "a3382d6934a82df7686998f33703a9e5ac3a9b9301549f8d2b31a7df416fcfdd"
    sha256 cellar: :any,                 ventura:        "5d69b498e1d29279dc4cbcc90b3e55ef373f1427418648b83fd2f5583b1e6971"
    sha256 cellar: :any,                 monterey:       "eb799cbbe16a078c0bd7d407ec7882f748e5bd39c0e2293e0d164daef96ce443"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0dcd40f0dbe5edb13dcad6daf7bfde12558c4c5190ab21a545b985f8fedf1609"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "glew"
  depends_on "opencascade"
  depends_on "vtk"

  on_macos do
    depends_on "freeimage"
    depends_on "freetype"
    depends_on "glew"
    depends_on "hdf5"
    depends_on "imath"
    depends_on "jsoncpp"
    depends_on "libaec"
    depends_on "netcdf"
    depends_on "tbb"
    depends_on "tcl-tk"
    depends_on "zstd"
  end

  on_linux do
    depends_on "mesa"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DCMAKE_INSTALL_RPATH:STRING=#{rpath}
      -DF3D_MACOS_BUNDLE:BOOL=OFF
      -DF3D_PLUGIN_BUILD_ALEMBIC:BOOL=ON
      -DF3D_PLUGIN_BUILD_ASSIMP:BOOL=ON
      -DF3D_PLUGIN_BUILD_OCCT:BOOL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    system "cmake", "--install", "build", "--component", "configuration"
    system "cmake", "--install", "build", "--component", "sdk"
  end

  test do
    # create a simple OBJ file with 3 points and 1 triangle
    (testpath/"test.obj").write <<~EOS
      v 0 0 0
      v 1 0 0
      v 0 1 0
      f 1 2 3
    EOS

    f3d_out = shell_output("#{bin}/f3d --verbose --no-render --geometry-only #{testpath}/test.obj 2>&1").strip
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end
