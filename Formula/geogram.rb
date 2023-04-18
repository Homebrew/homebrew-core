class Geogram < Formula
  desc "Programming library of geometric algorithms"
  homepage "https://brunolevy.github.io/geogram/"
  url "https://github.com/BrunoLevy/geogram/releases/download/v1.8.3/geogram_1.8.3.tar.gz"
  sha256 "f75ab433fe2402bd14a165ce4081184b555b80443f17810139f244f55af56e7c"
  license all_of: ["BSD-3-Clause", :public_domain, "LGPL-3.0-or-later", "MIT"]
  head "https://github.com/BrunoLevy/geogram.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "adb37385a59e0f278d70f0fce6c6a01db525bfa3b20d5927f2c993c3384edde5"
    sha256 cellar: :any,                 arm64_monterey: "b87eefae88560c648cef2f3adf71272ef8087d6e52660bd1365ced88a71f07a9"
    sha256 cellar: :any,                 arm64_big_sur:  "f21b8fd2520d1700df922a0886df81207cca18f96bb1041a05e7e2ac1790fe9b"
    sha256 cellar: :any,                 ventura:        "3a924fee6e4ad0e60576663964fb23fd93446471b2ff7cd4e5d5f63fba8f8ef1"
    sha256 cellar: :any,                 monterey:       "ae6dde8bc72032bb6ff9b89498cbc19aa38f8e580aeee0e84e8c44707a68cb70"
    sha256 cellar: :any,                 big_sur:        "6bd86fbe1008bbabfdc6a3f9aa731416fea32473cd58cb995395650b3a81124d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f229343cdf5470735809a3dcda06b8573f9c4185ba570d8ce932b74bb5b4aa45"
  end

  depends_on "cmake" => :build
  depends_on "glfw"

  on_linux do
    depends_on "doxygen" => :build
  end

  resource "homebrew-bunny" do
    url "https://raw.githubusercontent.com/FreeCAD/Examples/be0b4f9/Point_cloud_ExampleFiles/PointCloud-Data_Stanford-Bunny.asc"
    sha256 "4fc5496098f4f4aa106a280c24255075940656004c6ef34b3bf3c78989cbad08"
  end

  def install
    mv "CMakeOptions.txt.sample", "CMakeOptions.txt"
    (buildpath/"CMakeOptions.txt").append_lines <<~EOS
      set(CPACK_GENERATOR RPM)
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
    resource("homebrew-bunny").stage { testpath.install Dir["*"].first => "bunny.xyz" }
    system "#{bin}/vorpalite", "profile=reconstruct", "bunny.xyz", "bunny.meshb"
    assert_predicate testpath/"bunny.meshb", :exist?, "bunny.meshb should exist!"
  end
end
