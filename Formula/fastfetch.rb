class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.8.1.tar.gz"
  sha256 "5db8ef1b4eba470b55c905ab07e2188bb2e3b4bac7aa868284e0da58c3a36926"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "587b22b41203aeb074ecbde8fd42fbf81eeb21db93fa0b2d3aac3f57dd8ecbe1"
    sha256 arm64_monterey: "e4f9348bbe03561de4b6d55cdd557740ee22e3e118f00050511dfb386fab4a8e"
    sha256 arm64_big_sur:  "d62b2f6a57999492c2e16f447e5c57d497633d547fad3566729e7ce64b962312"
    sha256 ventura:        "c5c6208369ded1b2a5db4d875f3a93b5dda621fa32022e0f7e5aff8c4ce78009"
    sha256 monterey:       "f2d21ac38ab7bb72ea50029b13bfd9d81fcc0b4df2d3a7815c421d0258fb864c"
    sha256 big_sur:        "5077d6d8806e9812699de854902f8064fa8af5a3662db5b01226b56ad44231df"
    sha256 catalina:       "d980f2fd4d0eacd09f4821a982d27a5d52744fcacc18d26229596ad2b99a334e"
    sha256 x86_64_linux:   "8757d24b5daa28af495feec81f4be8fa5952c23df8f24185d8a0c69b5dc9269e"
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
