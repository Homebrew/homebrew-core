class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/37635/geogram_1.6.6.tar.gz"
  sha256 "08211b1d6f21e14701e3fd5c79adbe331cdf66b8af84efdb54cd7048244691b5"

  depends_on "cmake" => :build

  resource "bunny" do
    url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
    sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
  end

  def install
    # don't write directly into /usr/local/lib/cmake/modules
    inreplace "CMakeLists.txt", "lib/cmake/modules", "#{share}/cmake/Modules"
    # workaround for undefined _mm_set_pd1 in clang
    inreplace "src/lib/geogram/numerics/predicates.cpp", "_mm_set_pd1", "_mm_set1_pd"

    (buildpath/"CMakeOptions.txt").append_lines "set(CMAKE_INSTALL_PREFIX #{prefix})"

    system "sh", "-f", "configure.sh"
    cd "build/Darwin-clang-dynamic-Release" do
      system "make", "install"
    end
  end

  test do
    testpath.install resource("bunny")
    mv "PointCloud-Data_Stanford-Bunny.asc", "bunny.xyz"
    system "#{bin}/vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
