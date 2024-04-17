class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.9.2.tar.gz"
  sha256 "3ca9e48ed30c49fc50d5f64a2ce327a9f00ce4497feac01865c50086cc43e5ce"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sonoma:   "9910d4ebebf63f90c89b2bbaba0a77d98f3ec780263fe62a8513c28f041a672b"
    sha256 arm64_ventura:  "078fc194cdf85cf8db0270c10fb75bab35f9b1f8771c19bb3b61b482860ac9c1"
    sha256 arm64_monterey: "abb1b906b802e33a9c313cd1ababb10d23d5010d2764e89f0cec46cf2ba829e8"
    sha256 sonoma:         "7183c5064513ec66c199d5e06a4249832b829ab0de8de4c8adea2f928b1c1f16"
    sha256 ventura:        "3fe72d4be8cecd3ad9a3bdb85bc878dfcc354a03f626055feb2a873b3e616af5"
    sha256 monterey:       "db0f4ad8e02132eae382496f5ca69a7e048b2925bf750446c605ece67fb919e2"
    sha256 x86_64_linux:   "1100af8c51d479b62ff060d1e05255d0718f53c17ce43f7ec0bca05123706167"
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
    depends_on "linux-headers@5.15" => :build
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
