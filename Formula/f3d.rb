class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://kitware.github.io/F3D/"
  url "https://gitlab.kitware.com/f3d/f3d/-/archive/v1.1.0/f3d-v1.1.0.tar.gz"
  sha256 "93aa9759efcc4e77beac4568280aaeaca21bfb233d3c9f60262207ca595bde79"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "0bf1315a83f055c0a31d93d4ef7d906e774b8271979e4727ab3b544452a531b1" => :big_sur
    sha256 "09a4635338429517f2892be552dc1909aabb4b433d6ade7515826cec6588f0c3" => :catalina
    sha256 "d70d0469a39e6201238cb5212d6b900528d60dd19bc6949da2966a2c273b372b" => :mojave
  end

  depends_on "cmake" => :build
  depends_on "vtk"

  def install
    args = std_cmake_args + %W[
      -DMACOSX_BUILD_BUNDLE:BOOL=OFF
      -DBUILD_SHARED_LIBS:BOOL=ON
      -DBUILD_TESTING:BOOL=OFF
      -DF3D_INSTALL_DEFAULT_CONFIGURATION_FILE:BOOL=ON
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
    assert_match /Loading.+obj/, f3d_out
    assert_match /Number of points: 3/, f3d_out
    assert_match /Number of polygons: 1/, f3d_out
  end
end
