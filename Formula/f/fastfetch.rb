class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.8.10.tar.gz"
  sha256 "e3ea8388d79cc02ed1a6e45b8e5fec4068507ca03923386bdc9a7b3ff02d2a52"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "1ac980fc0880fd40ea9a1009ca7fe1c52ba3946dff70e0351d890b007900529d"
    sha256 arm64_ventura:  "05cdd7af376fb28e4978ebd74ef564415e376c51cfd49878a1e88aa0510e1805"
    sha256 arm64_monterey: "0f6eeaed3b281a2891f061c61aa1421a1e2e3fdf6bba589c35626912f97865e0"
    sha256 sonoma:         "d2150c46c38d32f2d6fc7df4f30006cd7d80077d304e6578e912c4e5f506445c"
    sha256 ventura:        "964de71c468169966d73af7c14167bf0d7023a9ad6c48e9b9b5e06cfce82ecfe"
    sha256 monterey:       "8e010704e4c60ae2f317644d724e67cd7a3ac028d61bdccab399d4124372b1c9"
    sha256 x86_64_linux:   "a8470940a35a1b2c76cec20c66d3dac8c610fc782d09714ea63e36b73c40f4ef"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pciutils" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
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
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
