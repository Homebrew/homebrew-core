class Fastfetch < Formula
  desc "Like neofetch, but much faster because written in C"
  homepage "https://github.com/LinusDierheimer/fastfetch"
  url "https://github.com/LinusDierheimer/fastfetch/archive/refs/tags/1.7.5.tar.gz"
  sha256 "e9807568c2c5a10240c635e1e9ad5dbe63326eb730ca3aac005e19d91d2cd1c5"
  license "MIT"
  head "https://github.com/LinusDierheimer/fastfetch.git", branch: "dev"

  bottle do
    sha256 arm64_monterey: "32f852d50d200f8e1c0dfeb27c55b2caa0d8258201e05610f463278758e74ce5"
    sha256 arm64_big_sur:  "2550a29c786559fb4ca2cd4a4be34c062af06b570eeebcb692eccec20e5a28ed"
    sha256 monterey:       "3ec7acc9019fad2dafdda89e206ca9887074854f04dbc289219f267f04feda90"
    sha256 big_sur:        "43723124be1e0680caf2b25257d18cadf82829d1f2c1b7ff8e1a76a8e3f1e22f"
    sha256 catalina:       "d01619be3cd21bb231c2cef6b764d367a9c8bf248e390cb9fb438e276c28ee0f"
    sha256 x86_64_linux:   "839cea8df541b485e957e4760d1c0a4b75bdb198286e63e5e7ce1a0f781d386d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "vulkan-loader" => :build

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
