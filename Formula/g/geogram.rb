class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://github.com/BrunoLevy/geogram/wiki"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.9.2/geogram_1.9.2.tar.gz"
  sha256 "ea5bc05e9971e739885ae1bc2800e921f16d0e23a877726b91ce816baaef8ebe"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a24fe57533f896da1d0661a892ac9fc26baf1cba0c2932c336312f9cd543061e"
    sha256 cellar: :any,                 arm64_sonoma:  "05dbb6eb600bbd857cefe2aaaafa674c0d6a9b9812f4b23569af936a65d02c82"
    sha256 cellar: :any,                 arm64_ventura: "ead52a3684e7869b78d48667639dd3f53b799eca4643d70972f1b26ac2a9cfc3"
    sha256 cellar: :any,                 sonoma:        "11b4532c94dd029456ba4e8f7529e7ab53b2a8007ae1636e334b9beb5523a039"
    sha256 cellar: :any,                 ventura:       "668b3280a048c09b1e27dcfb320b28c55efdfcc49252f8a56f2a437aeb57f74b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9e734074c3201163275cec7949fcd0db4a00263ea4d308f58a13d91ae702e9a5"
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
