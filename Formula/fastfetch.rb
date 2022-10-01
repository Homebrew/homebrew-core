class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.7.2.tar.gz"
  sha256 "f0778cdc6d33f5399bb82a8689b816ec3ff1d6b3eb74488e88d7a92a0bd3f7b6"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "master"

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
