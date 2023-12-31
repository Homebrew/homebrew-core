class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.4.0.tar.gz"
  sha256 "dbde7bb445f8e13ca8e2a324e05b6cda5bc7ed5121684d4dd0105cfb583c757e"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "88c33dc73460f6c874134fe8c1fb4d53cb99d8c9b5285999385fe934acfd7ae4"
    sha256 arm64_monterey: "3ab1f3e10e7fe6e733f97c168745cd19256a4364ae454f947fd775546c541f9b"
    sha256 ventura:        "f445f101f4bd53368ff14ba6b2f4ccdfdb934123004239a7cecf853a400202ac"
    sha256 monterey:       "eef281fdf43de346841a19942acb48b26180a9863400d9926663bec288e287cb"
    sha256 x86_64_linux:   "de76b63b601bc44e2aa0a42465d0887afad5c225ddcda6ada807c04166f1b49d"
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
