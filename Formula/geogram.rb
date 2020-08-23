class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/38314/geogram_1.7.5.tar.gz"
  sha256 "203349ff6424bc1d75f0a534b0b4626fc08e594109b5eaa7e82ee712f59bd24d"

  bottle do
    sha256 "16ffa419e614e6ef1c73e14eb6b358fc112d9e5bb35e4c1b92dcab8f89842882" => :catalina
    sha256 "ff58b787e0fa5c0b0608528dc76a94d8c76caa73b00102700f14e9a91e78aebc" => :mojave
    sha256 "c5d5de12f0d0e7f7eb53022e7f9dae5b09172e97040f4d10b494ed66a0c4fb60" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  resource "bunny" do
    url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
    sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
  end

  def install
    (buildpath/"CMakeOptions.txt").append_lines <<~EOS
      set(CMAKE_INSTALL_PREFIX #{prefix})
      set(GEOGRAM_USE_SYSTEM_GLFW3 ON)
    EOS

    system "./configure.sh"
    cd "build/Darwin-clang-dynamic-Release" do
      system "make", "install"
    end

    (share/"cmake/Modules").install Dir[lib/"cmake/modules/*"]
  end

  test do
    resource("bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system "#{bin}/vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
