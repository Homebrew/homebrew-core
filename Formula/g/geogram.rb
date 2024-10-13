class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.0/geogram_1.9.0.tar.gz"
  sha256 "09c0e28ffc08fdab1f2214ee32e49610d64972d052e890d3cc6dcb6bd25b5fc0"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "d406a0d8951aaac6513fb1f110f5ef4e7e9aa349681a90f48e69f2a37226ba34"
    sha256 cellar: :any,                 arm64_sonoma:   "098a179b1206c255fb60710e15db01c4800d615dff223099eebf5845a4706c93"
    sha256 cellar: :any,                 arm64_ventura:  "de7205ed12782950c36533503a3a4a60cb530a6420866b2c80fd0aed07325af0"
    sha256 cellar: :any,                 arm64_monterey: "42de7e1ac9aff5dd48bb95a12809cbc26edb1218b3fa28b4d9c669efe565f632"
    sha256 cellar: :any,                 sonoma:         "5d008a0fe04789fc181f51735be1f2b6c6dc117ecdc0e800a8b9160f62c3e8d8"
    sha256 cellar: :any,                 ventura:        "f731d2063834b82347928be139a415301afa7074edbc4ee6828da01490a7a654"
    sha256 cellar: :any,                 monterey:       "8e86639ce16d92f888f75ca768ea8e26cc5f9d5a91bc7b331d07a28b18be6941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b236ccd5d6abfe2a0e8d72271cbb8fab4cb56aa4e832b6255670088e46b30f4a"
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
    system bin/"vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
