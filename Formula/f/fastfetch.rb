class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.8.3.tar.gz"
  sha256 "f60c357738fe2f0a82fb2a11dd01015b5c36e8c3da394c448a065807b7a56953"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sonoma:   "87bb7db78824360c773b8ae5ab4ab82a1fd6842ef7fbdf39da9cbdc9b4dc286e"
    sha256 arm64_ventura:  "9ccc2a07c4132515fbe6a5b50e8b2ff488df3211fbd564f4309aac73460c59a3"
    sha256 arm64_monterey: "2739f544af84f82d8dfed8135088f4e44ef76e9b992df6525753c7d0b8b9e63b"
    sha256 sonoma:         "549fa8e0659a458a370f1688f79ba24c2a06bf31cbe682d27492d10c525ee5f9"
    sha256 ventura:        "f8bb5643006eae55a09219237478ee77c2b2129ec91b3b3ee492fcf0bed82cd3"
    sha256 monterey:       "3e8dd7ceb379a891d40394005fbb3d98f9a529602092286d1ec50d1e75ae2d9f"
    sha256 x86_64_linux:   "441496ad017f85da6d4c3e60501a294c16f78f9048d204ed9d7f9b4b6e9c0c05"
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
