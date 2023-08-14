class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.0.0.tar.gz"
  sha256 "447d37351d336a8928a7e482c0c085507b5a79b6800e17253c01a2f71e3d9c7e"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "f18ccf446da89bb42575ad4161036df4d293e3e8a7bd835e74929d592531cea3"
    sha256 arm64_monterey: "fd94550f8fb5b7193cba0f7b924fe2de45fdeb29fb9e30f17303c80e2bafe376"
    sha256 arm64_big_sur:  "97e12c4a596e9babe444d7b2d885629ec1691a06658542f58c3552fe5e043290"
    sha256 ventura:        "0f32d9a46d150198848e6441aec8940c63091dcfe0d3dc5d07492d9b790bb88b"
    sha256 monterey:       "ca2bc1c567383abc67d2e81247d39a8b75c62dab604bbebe35f48404d2c36578"
    sha256 big_sur:        "0ce6b678982376146b981134b8a71fa820adc8ecf2ed61137b0a384bc0cd6aec"
    sha256 x86_64_linux:   "e4495a383f4e25dc07a7afcc8d9315a2000cd057567ffe3a4266b42fd37d428a"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "cjson" => :build
    depends_on "dbus" => :build
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
