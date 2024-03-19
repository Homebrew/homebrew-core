class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.8.8/geogram_1.8.8.tar.gz"
  sha256 "698bc9ad9d58139fe9fdf3eab0596f5b418c4edd593eee960de98c0ab646d47e"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc8d8b12bedece396727ea7b89285ca6695e13e21204a2d23cda72e45aa78f70"
    sha256 cellar: :any,                 arm64_ventura:  "941304240c9848ddc5687a53b2aebdf362e4f7631d86fab8aeda423b9316559a"
    sha256 cellar: :any,                 arm64_monterey: "5d8a3d270497fd97f5299b3df0ea3d98ef14c72d0c27844b3645db140c90cabe"
    sha256 cellar: :any,                 sonoma:         "b9124d8896e3e2488687bbc1dd526d66822d5ebb00afbdf4a4b59721ea2cd905"
    sha256 cellar: :any,                 ventura:        "42fc31debff11c9e27ce9af444738702e6f00b7e3564a122c7ebff91a26a9844"
    sha256 cellar: :any,                 monterey:       "0962f79e3daee5d68da1f9386d4bed0b801a3cdbfc3cb64cbdfe36b73693eb27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1aae1a977dd567c516a8006cb94eb17b1b7def9ae8a77af82bf4072285fba3b8"
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
