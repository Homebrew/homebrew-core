class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/37934/geogram_1.6.11.tar.gz"
  sha256 "5d823eb8bc3b34cc5c7abd78320a81e7e79ae16374a9706a7069d53ca032caf6"

  bottle do
    sha256 "a50a856afcb09e79581bd15f5a2abc84fd6d42d3fb3cb7c7403e315c77de8a34" => :catalina
    sha256 "44825a928086db529724d520b545d661175a8c96eff2787a02c2a6b1d4571ef1" => :mojave
    sha256 "ae7ff1f9dece2397f97b7cd544e7c55f3e5f04599b6377bad05fa496a74bf767" => :high_sierra
    sha256 "4230cc8b3eb383800aaa5fa2d5b54f52581116d9348dfebd770ed2b0c800704a" => :sierra
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
