class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.11.3.tar.gz"
  sha256 "699ee59b0677121411a11119a06bdb5bc45dc04b551904c9d9d30477e2142358"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "1a821125e3dbab9f910b6b60f5463dc0651c6cf159813b49e0e56787ccab7f24"
    sha256 arm64_monterey: "1f880c1c6f79c36869c4d8a74000890e3621fccea952c9bcc654c80da1a79b60"
    sha256 arm64_big_sur:  "b979f40e02b9ec7c669b605ac9182ede509a2af79f231bb0a434965332d0784c"
    sha256 ventura:        "d41b76e8e536d60393ad92271f4436637afd6d6838d15c475125904be5074e5c"
    sha256 monterey:       "2a7a97539b01956167a43393b5df4737d64e3e38c4c07a94e163058eafb986bd"
    sha256 big_sur:        "c643b0fc4d0eb206b3cba3804296b52e08084bde705b6315a02aa2e503a0d0a4"
    sha256 x86_64_linux:   "0dca5b4c721b51cbf6f1b8e7b20d2d0402c7fed65a519d577e85a4ddce89be96"
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
