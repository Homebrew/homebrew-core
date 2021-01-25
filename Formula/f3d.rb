class F3d < Formula
  desc "Fast and minimalist 3D viewer"
  homepage "https://kitware.github.io/F3D/"
  url "https://gitlab.kitware.com/f3d/f3d/-/archive/v1.1.0/f3d-v1.1.0.tar.gz"
  sha256 "93aa9759efcc4e77beac4568280aaeaca21bfb233d3c9f60262207ca595bde79"
  license "BSD-3-Clause"

  bottle do
    cellar :any
    sha256 "0bac4019ea861ad37466e7bfbd3c5ce7cc497af88b84bc3b281a1e65c90ec570" => :big_sur
    sha256 "bb7240f16fcb91501863f5c0d47d602d79a51573b2ec640d99548598f78a25ee" => :arm64_big_sur
    sha256 "084b51e428b310c22349769db16e2d55ec467ce6711251536f63e33ef469c6eb" => :catalina
    sha256 "4bf7e46f38dcecc2ce4d6d4e6ef1f7d0418cd3b6578f3f0d44d9b6708f858669" => :mojave
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
