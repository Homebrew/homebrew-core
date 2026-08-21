class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.10.0/geogram_1.10.0.tar.gz"
  sha256 "2ef9f4fd992c6f0b4fc7075145d5d9c735208c6d844ff456271c4ab968423a5b"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7dea041507c173c11ee287a7aad72cadd835ff4e305593a23f33751509aef5c4"
    sha256 cellar: :any,                 arm64_sequoia: "ba6d12968c2d4b87a57b5195b01aa16a1ac3cea300134a356202aa132e19cf40"
    sha256 cellar: :any,                 arm64_sonoma:  "62b1820072198e0112de7359118eb7c5e0f1361dca248e8d5ff40e0b0c7afded"
    sha256 cellar: :any,                 sonoma:        "65ab6d0ad20a91aaa5aad14c3134c1bc9933bb76fbce0e8a20b6815fa981dc81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1fd67409ff23f9de80a6014194b77ea7c1eec955d71aa88eb4b1af94b1b6779e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7d5561f88a6fda3083a7e0019bb2f0d5b914704cf96ae247c778477dd7c1e9c"
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
