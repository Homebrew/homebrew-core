class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.41.0.tar.gz"
  sha256 "618259487b7d9055423d9ce11cb0db610b24b80413f4c590a56d73946098c323"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "09711d929c0ed86a9919f27629f474c82b1d75669c3fbeca4533ae2036988e37"
    sha256 arm64_sonoma:  "a3cbbe2badf5bd512da2adfedb7d22bf0d90609df0319236f400667288f4832f"
    sha256 arm64_ventura: "5326f67f1bf218e4c729d72bd4ba1c6144596d560f405f4200c86dce3ed2e28e"
    sha256 sonoma:        "e926f527c8c49f87c1a341baeda899fc7a95da9408ac6c43876b66e29d2ecb8f"
    sha256 ventura:       "73c4dff4677bbd69c9e402cf2711b0759ac2cfbd83f72db115b8c077f5294ae8"
    sha256 arm64_linux:   "c01f9212666734dfc7e942bc1906e737d96a9b1e3bed0aed64a4bdffeda161d4"
    sha256 x86_64_linux:  "7bc3c15b4f8cac8b9030cdb768dda710c0d661f0379c0efe7e3c651bab0ac61a"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
  depends_on "python@3.13" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "elfutils" => :build
    depends_on "libdrm" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "linux-headers@5.15" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "wayland" => :build
  end

  def install
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
