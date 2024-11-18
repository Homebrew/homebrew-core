class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.30.0.tar.gz"
  sha256 "5047f925e480e065e8b28da1e6cc5b31ffdc1ad205ec74a9ea709fb5bcaacd8a"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "0810a83c9da0060184eb37488283c5d87b4fa039b7528ba914ab6b0cee0bfee6"
    sha256 arm64_sonoma:  "8b02406528c5df4562959df2b9762e7d38f2521d18ca2ca25857add9fcadc925"
    sha256 arm64_ventura: "fa8231919977294dcaae05f01fbff22b4cd755e999fb6d0574bb17b106f4e040"
    sha256 sonoma:        "e9e391867de7e2dac005899da24b2247a1565942e374e4c6b5c05bed2a1c5b81"
    sha256 ventura:       "818bfbf4d9dd1e0006d0b98d9af6a939bdef68f1dcddf59b875b5aeeb4450f10"
    sha256 x86_64_linux:  "cd826660507122be91350d45e9367cd6bc0eb93d5f74bcfbcbdc058a1a7d9529"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
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
