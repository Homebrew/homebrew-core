class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0d72cc465af1adefdf71695481ceea95d4a94ee9e00125bc98c9f32b14ac2bf4"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7af4b0e2f978c95c22156f0b96ed9703fff312eff2db793cbed042344cb206e6"
    sha256 cellar: :any,                 arm64_big_sur:  "95857bb41de466899db3d6d5e70cae7d28df630bf4e8f5c0a4294e33dfee6796"
    sha256 cellar: :any,                 big_sur:        "ee3581e0af5e1892b168ab2af513d26063f025280395ff68d3dc07a35a10f8ca"
    sha256 cellar: :any,                 catalina:       "f4dbb8683a986d37326595af9c43777d8486d80874b30649efca79dbd77d0792"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2eb8e2a48fd10ba45b12685c98f7101863ed98ff50742930b7ade2e8fa9cf117"
  end

  depends_on "cmake" => :build
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5" # vtk is built with GCC

  def install
    args = std_cmake_args + %W[
      -DF3D_MACOS_BUNDLE:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DF3D_INSTALL_DEFAULT_CONFIGURATION_FILE:BOOL=ON
      -DF3D_MODULE_OCCT:BOOL=ON
      -DF3D_MODULE_ASSIMP:BOOL=ON
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
      -DCMAKE_INSTALL_RPATH:STRING=#{lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end
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
