class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.10.3.tar.gz"
  sha256 "55385feb4f4d7c16b3e8555afb20b030f3dbf446e225b09f1dcae163702225b6"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "724b46d0f89170d9a4e7a65df623d1e62588d1863095dc8187825ce00c1e505d"
    sha256 arm64_monterey: "dd71cf06148cc21eef50503e3b249ab29f61629b55bfae2933e8b8934ac21f98"
    sha256 arm64_big_sur:  "1351221109d8c03ac28b02fb8615d74001269bf85697354996f26b054a4b56a3"
    sha256 ventura:        "ca846985063531ef862220a0afde1dea975d40600f044b9977a7b14dd2fc1ffc"
    sha256 monterey:       "82cdc0561fc2437bfba1a976137b570a05e622cdaffedfe6134595bf9f46a18e"
    sha256 big_sur:        "5a7da362cef12def52dda1b1baed1022e34e8f01e9eaf8aee5fcf292a50cb2d9"
    sha256 x86_64_linux:   "248429ecf7ab438951620455dfac06891ecc1595d6ed1e702b3dd04c53c8df07"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

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
