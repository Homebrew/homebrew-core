class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.10.2/geogram_1.10.2.tar.gz"
  sha256 "f1f95967c412168140ba663748a170ad953f52226909d5f9409ccbecd71aff84"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "4cf270c4913a8174aff11297c6a3197c53a70fb88df15060bc516d7076af9b30"
    sha256 cellar: :any,                 arm64_golden_gate: "cd3acf5f984c03104700835b3a3976c7e876f06bfb989a2c533c801b6f7046df"
    sha256 cellar: :any,                 arm64_tahoe:       "9db602c57474ad864017b4ba87a50099457e52db648e2195d0ca8df63420fc9d"
    sha256 cellar: :any,                 arm64_sequoia:     "5d555eaa29afaa1bc7171923d276dca002d9206dd9563000cf1c579cbe95d7b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f5b9e87b63a9c67ce16b61031e04c656c400909c363f85d3f00a3cb198f9c113"
    sha256 cellar: :any,                 x86_64_linux:      "a53ba7e5f323c0f2de71aa4a13ac7fea81d37af0f23b1bdeef5730e059f0364e"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
    depends_on "libx11"
    depends_on "tbb"
  end

  resource "homebrew-bunny", :test do
    url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
    sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
  end

  allow_network_access! :test

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
    resource("homebrew-bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system bin/"vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_path_exists testpath/"bunny.meshb", "bunny.meshb should exist!"
  end
end
