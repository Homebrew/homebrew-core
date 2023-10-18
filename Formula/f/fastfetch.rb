class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.1.2.tar.gz"
  sha256 "62b02c7e48cb328c4381e7d4af4b23a7c74a2879eeea53525b8c45cc0e79e65f"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "a5fc25e4099442741cae3b692fcb7369e63644af643cbc90fbe69eaa81681ffd"
    sha256 arm64_monterey: "68f6cbb04fc55eecb71eef91cf21ba168dc08845b46408b967fbb4d7a4e5f8b1"
    sha256 ventura:        "31d45a55846a0bd82c579a20bdce02e4645dffe732057b35c3e6cb26839a3fa2"
    sha256 monterey:       "2233b7765eee69b09cc81db2828b27901a91b1a7a39a96eea678f67e2697a5a9"
    sha256 x86_64_linux:   "337d6e1d28a2da0678293b98c6f7345b65900ae87920640efe8193375f23d543"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "sqlite" => :build
  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "ddcutil" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
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
