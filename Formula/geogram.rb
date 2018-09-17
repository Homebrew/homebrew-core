class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  url "https://gforge.inria.fr/frs/download.php/file/37675/geogram_1.6.7.tar.gz"
  sha256 "0a1b5daf6ec8e798957f83f8512e355d9e20a420108c3c1c8143c194f758af5d"

  bottle do
    sha256 "4844e7fec342f5346eb4e183b89eb381d888be298e0a4f1e78abb19008cf36b1" => :mojave
    sha256 "efd1c1eeee7e1a48961b0a0d8174876cb75bd62c4a5591f936329cb17223bf52" => :high_sierra
    sha256 "a98db2a8d2dc6504ae8d54e31357cf87f354552d59c398046e0df55ffe49b92b" => :sierra
    sha256 "d0482303e55d4899107f5c9baadbad3bfa6fa4f60f46e18d8644439951a016a0" => :el_capitan
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
