class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.8.8.tar.gz"
  sha256 "179c4a4d9e725104ebabd5932b1d659a99dbdfc225a1ee0261944d168abccf05"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "7fe6335797736c6af4e4540d68d33fa0280b7036af8eabfb894fc6670eb45cec"
    sha256 arm64_ventura:  "2eb609cf7f5cbe9e04a4cc148dc9d5760c7740e8d261eac82164e73a4ba408e7"
    sha256 arm64_monterey: "c7e88d09f2274c2d29e9ea263779e9cf5122ee9d9432bc8e9fa9013d82244180"
    sha256 sonoma:         "ab422fad9a682ed2b03cb69694d2ea461ce2c4a516cbe5bbd0aa1322d6e1de35"
    sha256 ventura:        "526b1437d2f65fae3d751deee79a1794af14bcb285e8838fea8a2aeba2d99890"
    sha256 monterey:       "a4a853f898ed23a8724fe479e6a4b63a39540259b3e4fe918d4355195f2598bc"
    sha256 x86_64_linux:   "57ccceb8b40489ec7156347b0d0ff88f4eb83da2b0aa8112479804ecbb87a8ca"
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
