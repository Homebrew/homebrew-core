class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.7.4.tar.gz"
  sha256 "eabf1e5af377901b92717a4a87b87da9bf6799a34880bf6110cf24316527c48e"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "5d95f6b0da0ef3e71d2c3ba8b012cfec42f2c0a988234d987b16b5a033ed36fe"
    sha256 cellar: :any,                 arm64_big_sur:  "be410b28bc9ad774369d17ac25a94bff8be919474add200c8e9cdaf3e9d3031c"
    sha256 cellar: :any,                 monterey:       "20a8c911d3e71395a2c0a01040ecc4aacf30670b2a61b3b6d967e2834f431118"
    sha256 cellar: :any,                 big_sur:        "5c1261c614c6a975ed6a86241c2932ddc334804522f721f35aff2bd3163806e2"
    sha256 cellar: :any,                 catalina:       "d7179e65427a18ba75ebef073125c0877a9f5820cca3d694c9fff73121bba662"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "71f49630f29fe5db2ff0f8aaf3a40d65ae1dd9256d4480ea2032d4a60286d983"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
