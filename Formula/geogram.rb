class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://members.loria.fr/BLevy/PACKAGES/geogram_1.7.8.tar.gz"
  sha256 "28e70b353705faec555700d8a7b7b9d703687702f46866bad09e033f86a96faf"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]

  bottle do
    sha256 cellar: :any, monterey: "14eae5569bb7755822db7dd6db76569ff6b3a9ec14d52ebcd32a01d859209db8"
    sha256 cellar: :any, big_sur:  "c02fbf13cac94ee730282f326322b9ccc78a9b2747fea1ec31c937cafa543725"
    sha256 cellar: :any, catalina: "ef86799ac68bfd1f5e982acd10e991acf2f4b74f5c7623ac54b30a4af9a90bc5"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  resource "bunny" do
    url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
    sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
  end

  def install
    mv "CMakeOptions.txt.sample", "CMakeOptions.txt"
    (buildpath/"CMakeOptions.txt").append_lines <<~EOS
      set(CPACK_GENERATOR RPM)
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
