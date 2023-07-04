class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "3e5e6c2c16da4d7ccce8b6e316ab8007592a2bc0fc11a513f1ebac8c7f0f95d2"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea4c99012e19ad2523a9dba29f42068d89cac37720f0633793d28064c5d0bf79"
    sha256 cellar: :any,                 arm64_monterey: "7491ab9bdd77d2bc108189317d65a0712aefb1142aae095d7acd58f2bffa82cd"
    sha256 cellar: :any,                 arm64_big_sur:  "df7bdcbdca0774f4ff4a3b4e5dbf9906929184004159b096cc849df671791582"
    sha256 cellar: :any,                 ventura:        "fa22f84a2dfd658244a2c5f30d7ba08e2ef497aee292a7de6fe52575874eeede"
    sha256 cellar: :any,                 monterey:       "c02c294aad555af62c090185996eb64e77d58b92e730a55aad152c99034c6231"
    sha256 cellar: :any,                 big_sur:        "0c68b8f075631601d6715e8cf71f90376e6c426ec34f494a762c9fcc96302edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "214e7206f973add89d8b37e36de6d3c0ce2b154a9248324674635f19b5f3ac91"
  end

  depends_on "cmake" => :build
  depends_on "alembic"
  depends_on "assimp"
  depends_on "opencascade"
  depends_on "vtk"

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
