class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.8.5.tar.gz"
  sha256 "8d72869c91f3c4f6e7cd9bb91431147108bffbdc8c351aa616eb4a6c900386de"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "eee49b1dc0b64e70bbbb9aae4b241c24674105f076444627bc17f5f770c3f3b4"
    sha256 arm64_ventura:  "64d99cd12e3617821546eed488ff871d90d484a0a38cf714db6261d73dbaf4c9"
    sha256 arm64_monterey: "178f97b80d2b4464a1d02f3d7e2d8d1ac6c1e46092bdff88bd07b0b58ca5833c"
    sha256 sonoma:         "33e2fd22619904ee01bd226e9b692043484f06c8a4ea2ad83b41cbd2f34034de"
    sha256 ventura:        "9890073a72ff80ea09e86122d186bbe7e2e99db229b6863bd552c1c109d51967"
    sha256 monterey:       "4b57a549b24e16662398b0448a37576becedcbb0435af314504128c968dcbb64"
    sha256 x86_64_linux:   "69e5d0ff67f0c841bad30ae2efe316d918dd5c67bca842ceb0791130b087658b"
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
