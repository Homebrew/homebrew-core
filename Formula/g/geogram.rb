class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.5/geogram_1.9.5.tar.gz"
  sha256 "d560dd16d19bb9095f999d7fb6c3ba6b6380d0d4bd0fdb469614c118cf610e1e"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "29687107bb45ab0d397d927f900a3534dbbb26ebb8b3574fcd2422dccd0144d1"
    sha256 cellar: :any,                 arm64_sonoma:  "7b4d6118e4949d4767ecf2c1f5d78c644350acbeb9568780abf0a34d0152118a"
    sha256 cellar: :any,                 arm64_ventura: "ab91e6e70dcb12d181fd7b13efcf923ff3971c883f6ef1c4e1cac971da3867e1"
    sha256 cellar: :any,                 sonoma:        "28e36d51008b5787861e14c5c821144699b29602f555dab6bcd1a9379e6d7432"
    sha256 cellar: :any,                 ventura:       "283a675b700596c7536aad422bb5658b16c127ba6f0324763af56e877911c614"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27389e3bf7fc6336c68794710de6207b6ce1fc003c39ed6bc4dbac8b1bf79a25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "59a3b9c57e27ee8128ae157e42c7cd0c89967fc6b205a44e68fe867018d4b92e"
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
