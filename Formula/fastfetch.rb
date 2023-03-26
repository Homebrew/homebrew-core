class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.11.0.tar.gz"
  sha256 "900b3c19f56fca59fd90ae2a033f40fec00185f2a0078dabdcc13a27635dd989"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "72cf00fb0bf7c42e98c56ca42994697477375d57d2dd6f4dc5991ca893eabefe"
    sha256 arm64_monterey: "fd1d415e4710152759e1706a1f6b05b39a7fd60baf98cf92548c59ebf43e2ead"
    sha256 arm64_big_sur:  "52b370c7207b6ae42298272f606bc2a240412ea1f8bafeee56e3c7558db8af8d"
    sha256 ventura:        "f5ffe48095933016f30b586576106930da661d4aa531bca6a869622012c93e0f"
    sha256 monterey:       "9bb524cc2226405458ba029b83b502992156d102ae88a46092438708d1eb1e87"
    sha256 big_sur:        "630144021480f7b80c02b2c1ddae55d404c348a442d3840b26c5190841c605dc"
    sha256 x86_64_linux:   "6177c89f2fec45fa23539c7c4c63d785eca397007680e30d727c9d1c88f2e385"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "json-c" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "sqlite" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
