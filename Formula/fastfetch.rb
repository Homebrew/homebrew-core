class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/1.12.1.tar.gz"
  sha256 "4b45d41dd39f66488f719e7e3f82363209c2ee8ce26036532c1700f3d6bec917"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "69b8fcda6d8b01fd0f3d1c8d4cea589c3a618f1c4da01f6698b290cbea0c0fe0"
    sha256 arm64_monterey: "a11a23309eb40fbccafb013cf0e2ba6e825915fe8ae759d62e748260caf7276e"
    sha256 arm64_big_sur:  "961942de15d220c87f427ca00661b92ba23e67f2f69f52b75684a55c48ec2620"
    sha256 ventura:        "c508aa2608b62827ce6a4a97d485b000e4cc3e6682dcd039e35c4662b44552ce"
    sha256 monterey:       "d184fbc9827c9003771f36a7879e140ba9b6e59562132558eab1ab0dd14c6c35"
    sha256 big_sur:        "7ed3e411e31ab6f406df17d371aae54057d91c6b1f01a2457a9c18e1f87346ad"
    sha256 x86_64_linux:   "029de83438add04693ebf4f2e4a8fd5f4994d06b78fb10cabd1b220ececd4071"
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
