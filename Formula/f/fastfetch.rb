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
    sha256 arm64_sonoma:   "809502f7bf2c44fd9ca16c10dd7590b25e1d9547a47da2d65786c9991cea61b4"
    sha256 arm64_ventura:  "115d3b4d7cbf3d6a74608c2ad4b5981c6948f3d6516cb91186fad7c8d05c363b"
    sha256 arm64_monterey: "7f997c8f73e2dac87664e032fe60ac8ac7d61aeecb7d3f8d874dadf70522a8be"
    sha256 sonoma:         "1b7b35047fe734c018ea1e8643eb2ad0923b6905beea41ca79687d3986be80bc"
    sha256 ventura:        "da0ad725d4cd45023d5bc646b90a2292113100af040e372554ef53022866cd24"
    sha256 monterey:       "37bbe130ad180b4e44bf75fa1fbc1256319c8a377a78db2e51d13721a213940f"
    sha256 x86_64_linux:   "3cf9a969f3f590b73b35b66e7263a04194be6253edc56a7a59629ff684999f81"
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
