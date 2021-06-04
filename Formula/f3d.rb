class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://kitware.github.io/F3D/"
  url "https://gitlab.kitware.com/f3d/f3d/-/archive/v1.1.0/f3d-v1.1.0.tar.gz"
  sha256 "93aa9759efcc4e77beac4568280aaeaca21bfb233d3c9f60262207ca595bde79"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b199843d36c965a4ca51147d3114bfd5c9fd4a6aa1867b0bd7c34946734ddcd5"
    sha256 cellar: :any, big_sur:       "0fee7380115fcabee6ded441b91a607435b13da1b6fc478bc1db6101c779d1a3"
    sha256 cellar: :any, catalina:      "916545a539076217350a0858fcb0e016992c054ca48eccbad26c46091233419d"
    sha256 cellar: :any, mojave:        "0965ddce0fe74abbfb857fe585d1f504fc2758434d5a22f64663f2c519466193"
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
    assert_match(/Loading.+obj/, f3d_out)
    assert_match "Number of points: 3", f3d_out
    assert_match "Number of polygons: 1", f3d_out
  end
end
