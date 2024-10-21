class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.27.1.tar.gz"
  sha256 "de12f8cdb52bc1f123aa9b37813f009eeb09f15cbf43b033693c2936716e2626"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "33d373479059ce0a7cb8e6ea93d8b339a24dde20d2f797764e589dea0288a8ac"
    sha256 arm64_sonoma:  "58d1a486239e60bdf67da7a5f5ecd0b15b6140932987a2bb318684ea88c4aef5"
    sha256 arm64_ventura: "8819319d3b5fe64729a32eb706414da8d67c7bec69fd3c02ea2588130fb07bcc"
    sha256 sonoma:        "66ea198b32352f17fbd225d4420e49dfeee2b5038f80030ef7eecff548e773a6"
    sha256 ventura:       "c4a6097306f2dc77fbc6fcfd441c029748f2d6b687b6e318fd39861d014e2300"
    sha256 x86_64_linux:  "56c2bd15c6346bca02957dedaf9889e9752e04ad8cc7ab2e0f940cbe7507e227"
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
