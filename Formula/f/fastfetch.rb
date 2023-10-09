class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.1.0.tar.gz"
  sha256 "72d99687946774cb0a34bb48b3ef943db1b50d43e104fc20e6d775f5f3bb65b4"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "8367de5f0b046497f9b753ff42c39fe5163cb8ae5d845f81fd956ad118ecb582"
    sha256 arm64_monterey: "259a08557581bcf0b4d53319f6f15f1a984ec9b4e4022ee3934d3b532dab79e1"
    sha256 ventura:        "f317d01c7e4679e29256490e573b31bdc3909a69e34b67bd75de876bcbe205a4"
    sha256 monterey:       "f6d751bee16d68236b3a152c0aaa4c7eb62fce2818fa4dd0bf7af93f8522af23"
    sha256 x86_64_linux:   "daf78b3a1c6e1b7ae1738bc7bbc3c06b761918ce9e2898b836f69d7143cb5a19"
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
