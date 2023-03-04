class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.8.3/geogram_1.8.3.tar.gz"
  sha256 "f75ab433fe2402bd14a165ce4081184b555b80443f17810139f244f55af56e7c"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f87eca4e1d5bffd185848e63fbd51559d8cec3e1bdd2f35ac3aa61f6d090cb59"
    sha256 cellar: :any,                 arm64_monterey: "45629538ecb5b06fdcdd09e3687770866a88185abfe6b0042182febad64ffbbe"
    sha256 cellar: :any,                 arm64_big_sur:  "4ca3c5bba7cd0e645ddcef5428ca03b8a2acb5d42f6993b6c09ec70cad1b936f"
    sha256 cellar: :any,                 ventura:        "57961c3d87adfa3bce98fdf9530d906d283fccdffe810f47176458917af04d86"
    sha256 cellar: :any,                 monterey:       "c395bb9e853ced378d2d65c8e89229c7e0c13ff01aee7e61e964ae162e1aeff0"
    sha256 cellar: :any,                 big_sur:        "213093224d92bf9924413c2cee6da8cf30301c85c352319e28ebda093d3784d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0f19af5ac0b8a5f29b5d926d7772188661832cde5391aa1ae6a865795527dcc"
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
