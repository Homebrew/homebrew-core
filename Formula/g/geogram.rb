class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.8.9/geogram_1.8.9.tar.gz"
  sha256 "6d986bb1344b9ce3e5fb76651f779b09754433bc6aeeacf12d1dd6b0fefdb320"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "76ae1c7827f35b9175af7a595da70d6e4c9c86f8df8c35d192ded764af6a0e8b"
    sha256 cellar: :any,                 arm64_ventura:  "a14b175f241f8f09563a1bf8bb4ec681172bf64301784d7c6d324e2abd909d14"
    sha256 cellar: :any,                 arm64_monterey: "aa5507944417677db1c1ed6674fe3be952c951c02c1e19e5149cbedda221f8b8"
    sha256 cellar: :any,                 sonoma:         "d898db01a44966a962f157d8517630267432ab170a2bfa16b00fe259547bfb5a"
    sha256 cellar: :any,                 ventura:        "706b66727e7bf14b8ac0eb058154acd6d406c747a473feb36f889ac4916c5e67"
    sha256 cellar: :any,                 monterey:       "cfa7e9eaa2383d65d05988719ff17dd267cd7cc22040d24cbddf8f67c7701c58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "436db57deb59a654df6f67d1dc11590db3f83c45799cad9d83d93c39941e7e47"
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
