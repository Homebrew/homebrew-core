class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.8.4/geogram_1.8.4.tar.gz"
  sha256 "98e9c2de1dfad795296ea62262c6b3d74000ef5d2cd903af33189592ea0a8a6f"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e942b9e41c7318f56a28a8a9d7d299da6373a0eb7f3670d714225314dedaa754"
    sha256 cellar: :any,                 arm64_monterey: "9a5e4c3ee1bf17f5e52588b5244a4b5f6de2bf882fe0a4c11b6fdb4e6df6561e"
    sha256 cellar: :any,                 arm64_big_sur:  "54ab46644879f7dfdd976581cd63831cd6803e45f0267f42186775c16cce95e4"
    sha256 cellar: :any,                 ventura:        "16ae176fdb0f061d782c5b7114e3f87cd155550f5af82ab79916c31f2b09d573"
    sha256 cellar: :any,                 monterey:       "b81c3f16f8f5ffff9071c29c0cb6f1ccdb181cbe5f7a8fb2d44e3290489a20d6"
    sha256 cellar: :any,                 big_sur:        "03e140b0d80779b4560026a8df1fa4727ca192022063b45e8c8c56f7f86c4b27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c5c94c304b70df24cf669fcd0ed305c08d73c49d1db1d59f1b3d1e68e167821"
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
