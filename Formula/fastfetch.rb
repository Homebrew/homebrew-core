class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.11.0.tar.gz"
  sha256 "900b3c19f56fca59fd90ae2a033f40fec00185f2a0078dabdcc13a27635dd989"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "15b7187ea861c2110c3ed01c56dcecdcbee58b60dc50ef892ab99746c31abedf"
    sha256 arm64_monterey: "c84c166bba95c675ec36402b5704207d8881763194cf4736b1dcd95cc8a19a45"
    sha256 arm64_big_sur:  "0cef9df1b1c671094488989ec99b953eb1d2231d753a3ece48aad97c9b85d9f4"
    sha256 ventura:        "2b43cb3177edb281da601fa7413b8166a229618a2be243acee5d6f6d5fb33298"
    sha256 monterey:       "448be07a44648cdd3f637bf0956f0a7f2e3a48c61beef21a834e32ff2f641ceb"
    sha256 big_sur:        "6491d5c1e62fdd4d121a42462b694fbb37cd43e3ace99e2ab7b21bee1753a9bd"
    sha256 x86_64_linux:   "baae2fe968ce7c455c24baf17fd222e95cd56bf3708bddbea4e25fc68878fc26"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  on_linux do
    depends_on "dbus" => :build
    depends_on "json-c" => :build
    depends_on "libx11" => :build
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "opencl-icd-loader" => :build
    depends_on "pulseaudio" => :build
    depends_on "rpm" => :build
    depends_on "sqlite" => :build
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
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
