class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0d72cc465af1adefdf71695481ceea95d4a94ee9e00125bc98c9f32b14ac2bf4"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "febbe7bae8d515424ef1b91f600658b5c53f890f198b90a1e3ff46e360f62c49"
    sha256 cellar: :any,                 arm64_big_sur:  "7e688e6dd0ec957a961b5ac8be3db927c960ddeec693648fe86f9d436f06c737"
    sha256 cellar: :any,                 monterey:       "d19ab0b49754f24325bb08e9f66de9f3824a992a471894fbd67fbfd3c2c5e527"
    sha256 cellar: :any,                 big_sur:        "a01ba382b5b5e63b8da5ffccd5002ea81f4733309ce1894575f0d8a80614cfdd"
    sha256 cellar: :any,                 catalina:       "ac965c5f65b9bb06e16b8d7483220d44f56672246377b0d9d5f11362ce35b64e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6fd08d47ce278716e1a238aafb6d1dd637f316196f1794a23f17d1397d77fb98"
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
