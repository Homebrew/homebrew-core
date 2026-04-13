class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.9/geogram_1.9.9.tar.gz"
  sha256 "65402f3ce4b40efab178874c4ec1a8852f0ca1ab4567d72000d53efcaff52214"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "593f6a7159f6b29e38195337ce04dcfb32a7c1fefad91546a7de652bf5355e5c"
    sha256 cellar: :any,                 arm64_sequoia: "aa58b4d13b829ff41faa32fd887d93afc98063f5ff8b017b021a5778e6483968"
    sha256 cellar: :any,                 arm64_sonoma:  "c8ebe4e61dc9e10b336eff0aeab433b797e87809a28f7926ce0754788fc9a248"
    sha256 cellar: :any,                 sonoma:        "d0ce34b07db5d07b7536f0ce06ae4812e808f4981d9e9c2410e3b600f846ff55"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae2cdc67498632efba06345add7b145d3eec9a09e0efd1e01d7fdc98e4875960"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bbd24cf08a9f404207b1c09c273ca686f738a36d60bb8b2b0165750deba2972e"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
    depends_on "libx11"
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
