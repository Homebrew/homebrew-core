class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/1.12.1.tar.gz"
  sha256 "4b45d41dd39f66488f719e7e3f82363209c2ee8ce26036532c1700f3d6bec917"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "0cd8c41408ae8352ad893dd71424421cb6d97eb5f21f27c943f933fdd13b524c"
    sha256 arm64_monterey: "8e8004df2a2b0b498130e38bec4a04bfdc975b7f90cedb5d60eef527ca1069a5"
    sha256 arm64_big_sur:  "9389384a07e936ae400110842aa7e08e22c677ba9463eeb6f5fe23f3897731a4"
    sha256 ventura:        "5bf82a2667b3a37df5dabd24d5eaae743f120637d30d4439b6367f720b47d996"
    sha256 monterey:       "6faeaf9d52e6fcdcb56f44348e7a518d03678fc2f29aa2a3fc97ddd8ea4e4cf6"
    sha256 big_sur:        "cd8e96ddea10f0b5e39dfbebeb2600cf69eb40f5212a23989fc897fc0165f9b0"
    sha256 x86_64_linux:   "446ff8eca4bbc9ca86d079f33ec7451e2e1cbc732f7137bf30d05c484aa5612d"
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
