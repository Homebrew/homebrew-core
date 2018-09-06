class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/37675/geogram_1.6.7.tar.gz"
  sha256 "0a1b5daf6ec8e798957f83f8512e355d9e20a420108c3c1c8143c194f758af5d"

  bottle do
    sha256 "279b1bb9d8c52aabeab534be248d9c7c126565998bc0b7de4ec3e41a3c1f915a" => :mojave
    sha256 "6c20bea924c40ce4f562ed335b3b4212714c8d68701e49dbe2f0d494cd374c1a" => :high_sierra
    sha256 "25450ace93eaf2c390501e144fb49e166d791fc3dcd4863e13841b3da2e528b3" => :sierra
    sha256 "160e9ea1e305ae1c73e65e2c0b87c89c0530b0dc8a80cf592d2549b2c04da76e" => :el_capitan
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
