class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.8/geogram_1.9.8.tar.gz"
  sha256 "6df1186d8e7ed5a7ee02cf486f823cbc74400199822709b2b3faa9b7d6596c96"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "fcbcffb58f843416edb93e723c69ad4f863ecf415afed56004f573aedc221e77"
    sha256 cellar: :any,                 arm64_sequoia: "f6eceeb388082e67fa7bb28980f309d7aa9b0371a85f773d2199144e6dd10b48"
    sha256 cellar: :any,                 arm64_sonoma:  "d2b2962192fb8cabc7df065a773c8208fda5ac12313e9f261d8a0fb3b0bbdde6"
    sha256 cellar: :any,                 sonoma:        "8172ee2fdd0d49444ca551c0872707f02b8ae6ab79fc33eae619a6d385ccd440"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af84f2817f95d088a2aa5a2ea55d6a3f0e0a969a37d32a04e4d6a931d45ff04c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ed8a1d410f9ecbb2ee5fc85576e947ab231b78026b08e909d9776d623635439f"
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
