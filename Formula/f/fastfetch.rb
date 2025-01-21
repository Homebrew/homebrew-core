class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.34.1.tar.gz"
  sha256 "856920a6484a324088bbbcaf608555c74168078fd34cdbde4d3e4af88bc5cb5f"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "5b9721afb1ea40a6712c9d9b902b5f6424ecb2a834cba3a1b4b4d91745954d75"
    sha256 arm64_sonoma:  "d7bf793f29124a0591c6bdbd54d5ae7b9f9d74a4688c1f48108ca84e80754dd6"
    sha256 arm64_ventura: "d8b9f4c84a94899c1d3f062df66424095d502550d8e930f9b2fceeedc49307fd"
    sha256 sonoma:        "e5efc3b559b7205f3a1fff9ec9af37f2793cab8660c51fdf84ed387380539e42"
    sha256 ventura:       "e3a23d0d0587b059ab2405a2431d9de923440319eecbc43a39de2f21e1655223"
    sha256 x86_64_linux:  "8e572f0603580837251f61e07d19fe9a9fb12d41fa515fcf916d9b9192445f7e"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkgconf" => :build
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
    args = %W[
      -DCMAKE_INSTALL_SYSCONFDIR=#{etc}
      -DDBUILD_FLASHFETCH=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    bash_completion.install share/"bash-completion/completions/fastfetch"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --pipe")
  end
end
