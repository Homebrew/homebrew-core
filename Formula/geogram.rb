class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "http://alice.loria.fr/software/geogram/doc/html/index.html"
  # Homepage links to gforge.inria.fr for downloads, which gives a 403 response.
  # We're using a GitHub tarball unless/until upstream finds a new home.
  url "https://github.com/alicevision/geogram/archive/v1.7.7.tar.gz"
  sha256 "7323d9f6a38fbaff3e07c47955e0c8f310906871d38171536ec8bc0758e816aa"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]

  bottle do
    sha256 cellar: :any, monterey: "c825e078da693cc077b5655eebe374f753dc78620b87a73d6603f787fb248a0d"
    sha256 cellar: :any, big_sur:  "c31325cc34b205bb39bce490babfd8948dfbea2e5ce3a2c8ee402c8efe50b106"
    sha256 cellar: :any, catalina: "8766335d1707cf361a1093845f1b35ea15063b06d5bd96bb4f175d7260ff2a2b"
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
