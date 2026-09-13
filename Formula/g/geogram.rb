class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.10.1/geogram_1.10.1.tar.gz"
  sha256 "30033340a0dfd86f9e15a8ffdd7c1e6d49b967d3f26fb96cf3dfd1a502d8eba2"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_golden_gate: "bd1359d685c22eb4a4f2165587e26df33f84b634ae196c54ed789668a34273be"
    sha256 cellar: :any,                 arm64_tahoe:       "fb12c44bebf7f24e0e2bda6a66e5b27f3549f172ca528151d7345d32ca4c9c2f"
    sha256 cellar: :any,                 arm64_sequoia:     "299b18cc76b361d8431319b937e5b0b3d9b69f701f04d8efb88687daa77d4efa"
    sha256 cellar: :any,                 arm64_sonoma:      "54c42b51793db63797bf35d106ec4d771a7a16b3b568bd9fa1399048376f185a"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8ab68f7499ea114239716a856b06495d8662615f68cef746efdf5befa927208e"
    sha256 cellar: :any,                 x86_64_linux:      "4d85c1f8c05b8a9a5c4446d404e90f3fb4a5fc2794509dc129d1b31701c8ece1"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
    depends_on "libx11"
    depends_on "tbb"
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
