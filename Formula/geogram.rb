class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://brunolevy.github.io/geogram/Releases/geogram_1.8.0.tar.gz"
  sha256 "7e59db5176ca22580055a5c48862d6fd50399f33551ab9bc20c80a4cc0adeb9e"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url "https://brunolevy.github.io/geogram/Releases/"
    regex(/href=.*?geogram[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "68878fb9bea83c3c49294f8eba28763c739c3fab9a69a7dfeeb9dc712362929c"
    sha256 cellar: :any,                 arm64_big_sur:  "6e074cfbe89f210ee31944d0f28d479110072036d0f9e1a82eb80bbbeaee2bff"
    sha256 cellar: :any,                 monterey:       "7e45ba031704d12d3ae114d063755c8c9977bdad41a2893b3a101b93ada74fe3"
    sha256 cellar: :any,                 big_sur:        "4f6fec4a8880e11fa600ebf7bee5456471e60a3e764012a67b2e28593075c13e"
    sha256 cellar: :any,                 catalina:       "1944cf02f77aae7134804276ee78052cdccf06532a2039a32e44d33d9cbd5997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02cf25788c6614a20b1a33347605d8bd4d6e7653e99d8f420b43b7fb7b053d24"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

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
    platform = OS.mac? ? "Darwin-clang" : "Linux64-gcc"
    cd "build/#{platform}-dynamic-Release" do
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
