class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.3/geogram_1.9.3.tar.gz"
  sha256 "3ae6ffec34e1624bec342988c1cd8ebbc8cc74a8e5c8d622fa7ec45800197a1a"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7cef108dad849b842fedd772f746296eebd61203fa2403f9dd182747c23d388a"
    sha256 cellar: :any,                 arm64_sonoma:  "b0b000b57cdcb4e694eaceaab04356fbbef4ae5d4413801dacd5b1e3bcd2c2b6"
    sha256 cellar: :any,                 arm64_ventura: "ae4644d0ec6cd87e93758ff64f33871baea0bf49b1da8d5163b648e22c2aefc8"
    sha256 cellar: :any,                 sonoma:        "b353e76642040f2b4d8da8539b819f058d5fbe377ecb9b1bf50a2545c798d7f7"
    sha256 cellar: :any,                 ventura:       "77389c326a8f63e956abef1e2a6a5a627f963dcf846eab9e95a2fa8d3a727f8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0327682d9df40abd6eafb77c537c66d42b9d68918324d58082dfdd2d057a7cbe"
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
    system bin/"vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
