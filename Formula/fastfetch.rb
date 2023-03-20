class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.10.3.tar.gz"
  sha256 "55385feb4f4d7c16b3e8555afb20b030f3dbf446e225b09f1dcae163702225b6"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_ventura:  "75b8ed1f9d6a49ea1151f745a56d8f384d7832031309980042873289b4ca98ae"
    sha256 arm64_monterey: "7abb0c38ed062cae9180a470d148a98e1066cf091b3fa6a1174aa8d6e16257d7"
    sha256 arm64_big_sur:  "d2dc385192cd11cbf0e93c5abb96604f2a6c54297cd64f129d841d9cd3214bd9"
    sha256 ventura:        "8f5bebea27207fcaae807df3d4713eac87574b22e09132c9dea2047dfaf82f9b"
    sha256 monterey:       "9a0cd67b337ca945fb6f9992ba77610bacda8147f510c5ece7a8c65011bb148e"
    sha256 big_sur:        "0b2ea1e43b573495aae25c57ca1d3576461edb954ae3643010015cb7d05a0285"
    sha256 x86_64_linux:   "3431af9bb1988a8fec76e570a4c7b12c4dc6aad6f8a42a6f07521f91dc39369b"
  end

  depends_on "chafa" => :build
  depends_on "cmake" => :build
  depends_on "glib" => :build
  depends_on "imagemagick" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

  uses_from_macos "zlib" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_SYSCONFDIR=#{etc}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "fastfetch", shell_output("#{bin}/fastfetch --version")
    assert_match "OS", shell_output("#{bin}/fastfetch --structure OS --logo none --hide-cursor false")
  end
end
