class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/38314/geogram_1.7.5.tar.gz"
  sha256 "203349ff6424bc1d75f0a534b0b4626fc08e594109b5eaa7e82ee712f59bd24d"

  bottle do
    sha256 "7183148a73e4f3c1179523f7faf02446daa3bf34a40cd3531f23b65c6ecca689" => :catalina
    sha256 "eb84b21471b52d7b54b7da2fcb73e5d5411ce3e17938c496a8e055870796bb86" => :mojave
    sha256 "3666ffab4e601d92a335d69cd391824d876b8776aa380bd467ae55138b68dc2d" => :high_sierra
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
