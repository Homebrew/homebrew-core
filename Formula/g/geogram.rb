class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.7/geogram_1.9.7.tar.gz"
  sha256 "b6c99fbdbefd633f03443c9c6359dfb6eb26cda0a54202793a633cce34cff6bf"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "339c1b2f4c08c37877ed0ee8729cf875d03c69ba49927a0023fb4babc05f7bf2"
    sha256 cellar: :any,                 arm64_sequoia: "14f837b32d5bda21736fdb8427ce9917498d88fa57a96baeda598ff0b70277fd"
    sha256 cellar: :any,                 arm64_sonoma:  "86cdf2e7221acab9b10bc56741384f246646d23cdb36d8e81e83bafb5d130903"
    sha256 cellar: :any,                 sonoma:        "aad14ec877ebce04d7f95cc99457572aba9b64cefd693f49dc34690540de82fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2097eaf3fe7c590ca188c708c3d8fc10493c23156f27e6eb61912a10c958e1b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31f19bd58253d1ebdfe5d0d467b2914299e9c3debb533f5a45e7709cac7ffa50"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

  def install
    (buildpath/"CMakeOptions.txt").append_lines <<~CMAKE
      set(CMAKE_INSTALL_PREFIX #{prefix})
      set(GEOGRAM_USE_SYSTEM_GLFW3 ON)
    CMAKE

    platform = if OS.mac?
      "Darwin-clang-dynamic"
    elsif Hardware::CPU.intel?
      "Linux64-gcc-dynamic"
    else
      "Linux64-gcc-aarch64"
    end

    system "./configure.sh"
    system "make", "-C", "build/#{platform}-Release", "install"

    (share/"cmake/Modules").install Dir[lib/"cmake/modules/*"]
  end

  test do
    resource "homebrew-bunny" do
      url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
      sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
    end

    resource("homebrew-bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system bin/"vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_path_exists testpath/"bunny.meshb", "bunny.meshb should exist!"
  end
end
