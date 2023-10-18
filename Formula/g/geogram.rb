class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.8.5/geogram_1.8.5.tar.gz"
  sha256 "c4b253589bb9cb6df52e66b430c48a9326db6ac7bce1626027f763fef68194fc"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "16309c8126be9f72eeaf6b09cb6b96bb2a5fdd32f5c583853c7032a666578d44"
    sha256 cellar: :any,                 arm64_ventura:  "00df115f95e40dc5d5da0332be046a53a455d9504813f00479ba91c408eaf7e4"
    sha256 cellar: :any,                 arm64_monterey: "85f31c1a29ff4f60144ab8e8e6584c142896e39becf1a545878fa55e2de99710"
    sha256 cellar: :any,                 arm64_big_sur:  "e5e7b73c38cdf3271ce53377331388752f12c2e7bbe9dd6638eebe86fd220daa"
    sha256 cellar: :any,                 sonoma:         "16d456e4d4465af4313b27d59699689b4bcaa5d98313a187bf4c46f110f1bcdd"
    sha256 cellar: :any,                 ventura:        "495f02d3034e827b442d267e1cbaa320df17686c0340f53d0aa514c075b9fde6"
    sha256 cellar: :any,                 monterey:       "82e4f575e86bb8eb7962b757bd79bb6a83a008be6f8cdc32d597236103e91653"
    sha256 cellar: :any,                 big_sur:        "13b2eeb0732896a1bb692cf191455816a255efde968660b3d351358351ef99d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2432d87f423e6818471a9c5800f27a17e5a2b5385cbfe68bf33cafca1fee692c"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

  def install
    (buildpath/"CMakeOptions.txt").append_lines <<~EOS
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
    resource "homebrew-bunny" do
      url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
      sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
    end

    resource("homebrew-bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system "#{bin}/vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
