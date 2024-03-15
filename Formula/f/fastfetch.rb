class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.8.9.tar.gz"
  sha256 "36211738354869a274c8b9c145258b86a9156573586e2fba0c5e8410d5a8c469"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "6f62d32e8403fabe898d08b1b7c3affc680b376dec27ca4e7f35937631eef0d4"
    sha256 arm64_ventura:  "813301d106d5944f4b1addb4b6de4f679fe0b4c80c35bf5708a163297215efcb"
    sha256 arm64_monterey: "2b3a9249486215e7788068af9ed8c62e5bee13b1268113f67cf400f19046d6a2"
    sha256 sonoma:         "fd4e15df9c13b4a0fd53828ab026b08e00aea14e2574e0cd1ff47d7841d8773e"
    sha256 ventura:        "3753c887901193dc9ac9e11ba33d606da6e52ffbae7a6fcd4d663d34d42dfb6a"
    sha256 monterey:       "2395f76136b44ea9daf69d8093fc44a296033391faa2626d38175e5f511985be"
    sha256 x86_64_linux:   "4498648c05111a601e5fb6e9f8f9f66a665bb37ccff2dd7ff2eda0fc8e2d8d20"
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
