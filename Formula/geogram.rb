class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  # Homepage links to gforge.inria.fr for downloads, which gives a 403 response.
  # We're using a GitHub tarball unless/until upstream finds a new home.
  url "https://github.com/alicevision/geogram/archive/v1.7.7.tar.gz"
  sha256 "7323d9f6a38fbaff3e07c47955e0c8f310906871d38171536ec8bc0758e816aa"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]

  bottle do
    rebuild 1
    sha256 big_sur:     "16a2b60356439f3a481677989c256085696690a1599636859bc18a31723e075d"
    sha256 catalina:    "4345844b616fb74fbb2124a0c7bdaeb222c62704908b358427bce7122cb9404d"
    sha256 mojave:      "f263799496ffc570463ce635eedd9287f81502b06f72142a7829c0b857185079"
    sha256 high_sierra: "f0eedab23f61affd89684a7e1492cfc2cc8deffa4ca7ebc8459a5768a05876f3"
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
