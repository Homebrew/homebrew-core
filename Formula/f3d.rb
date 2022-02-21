class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0d72cc465af1adefdf71695481ceea95d4a94ee9e00125bc98c9f32b14ac2bf4"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2caa72702320bdd5b7dfbedb8852f56a4b8681e8513beed387a1149c52deca45"
    sha256 cellar: :any,                 arm64_big_sur:  "01a5e5ead6c4655d1fbf6d2719026e64bfe6124fdf704654f661af0bc8f94802"
    sha256 cellar: :any,                 monterey:       "ae600cd81acd26f328391bc6a1af2689bfbe301928c1b2f33b735863a22a53ed"
    sha256 cellar: :any,                 big_sur:        "21b7488d08ee349bbbbd6524d90047d4bb545be38178b4314f77b6f8c9e2d635"
    sha256 cellar: :any,                 catalina:       "2f1e76ff8693fb79a4655b832d21c5a440e7aac9c85775a3b75eda5c46db91ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ada81e427f873a0c70ee998ba84197d0050e6d2140807469db94de6cda524ad"
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
