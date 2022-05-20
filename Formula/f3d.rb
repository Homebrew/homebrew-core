class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://f3d-app.github.io/f3d/"
  url "https://github.com/f3d-app/f3d/archive/refs/tags/v1.2.1.tar.gz"
  sha256 "0d72cc465af1adefdf71695481ceea95d4a94ee9e00125bc98c9f32b14ac2bf4"
  license "BSD-3-Clause"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "ac70f7b75dd20fbb59976ad90a62a14db3190c90f2f97294c39771e74efaf48e"
    sha256 cellar: :any,                 arm64_big_sur:  "2ac4a39f7a33dcc71cde0e907f5f0610facf5375680e822ef66a24bfd18abdda"
    sha256 cellar: :any,                 monterey:       "0a2fa1c92c87e4a39b7391f3e8f1c1d636ba6c1b5003d3cb72051a2c8015c87b"
    sha256 cellar: :any,                 big_sur:        "1a6cf080c920572b651e567e839df1142dfc95e7e93200890a6abb6f9f60878b"
    sha256 cellar: :any,                 catalina:       "e1528f1a04999a5d1cc8597dea5d0ebeb3a6139e0bddb61ee5dcf72f076a58ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "628f05faa164491788ca3bc4765684f9cd473c94f4ca0369c5d677db0c81eb9d"
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
