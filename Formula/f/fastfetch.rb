class Fastfetch < Formula
  desc "Like neofetch, but much faster because written mostly in C"
  homepage "https://github.com/fastfetch-cli/fastfetch"
  url "https://github.com/fastfetch-cli/fastfetch/archive/refs/tags/2.47.0.tar.gz"
  sha256 "c1482b8075718a2b2db95f823419b04b81384237fdba8af56092f184e89797d3"
  license "MIT"
  head "https://github.com/fastfetch-cli/fastfetch.git", branch: "dev"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_sequoia: "734a6f21fcaa990b9c4845d38dc55792127c333ef648547af600180d11a019fe"
    sha256 arm64_sonoma:  "3e2cc6b4eace70283485abc8a6e25513c6a7df1b344fbf1776aad626e96f2b97"
    sha256 arm64_ventura: "09f2e9a9be2f28a050783f199803857a88acee522579ea201e4a0ed4ce34b18f"
    sha256 sonoma:        "9441e5d3e82e0da44511df5b3b0ab51bff83ed9856a3cdea1e7ca67327ad995b"
    sha256 ventura:       "aa4f9d5278c545a2d6116220e0ea28df6c56e93050bcf6ee8f79da339b3c7a44"
    sha256 arm64_linux:   "62ab32e7f095eaa6cf92b46236b7fc6c94a5178b70b928e676d14d5b506d2cc4"
    sha256 x86_64_linux:  "b119959409dcf475aab1df64b384f8ab1f9d898a7db533ae6a0338b21f0d6480"
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
