class Pianod < Formula
  desc "Pandora client with multiple control interfaces"
  homepage "https://deviousfish.com/pianod/"
  url "https://deviousfish.com/Downloads/pianod2/pianod2-392.tar.gz"
  sha256 "d3e24ec34677bb17307e61e79f42ae2b22441228db7a31cf056d452a92447cec"
  license "MIT"

  livecheck do
    url "https://deviousfish.com/Downloads/pianod2/"
    regex(/href=.*?pianod2[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "e0f97c293764bc1d6ec7e9e9e2d18d554b39ad95071e295592e33e4087376064"
    sha256 arm64_big_sur:  "f2fa087fb17f1e2cfc9aa1fb33a2a2c8438a024e06d510c43f2c15c9bf0cc2b8"
    sha256 monterey:       "b9aa59f530b8a6663a6483ef9e5dc18d28f024aaada85113b5ddcca42481b3d0"
    sha256 big_sur:        "4f100221aa096f62ff4accc0e2797781c4df7c4dbc4496668f6e2615fbc084fa"
    sha256 catalina:       "ca896c858edd71e8ec1545c4f8c5a107a40bfafa23304b521d1a5ee1c5861d01"
    sha256 x86_64_linux:   "f00f9a7fbdb2e6483a1ffa15b5d6841d312e742b8907b60321ebdb9fce067210"
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libao"
  depends_on "libgcrypt"

  uses_from_macos "libxcrypt"

  on_macos do
    depends_on "ncurses"
  end

  on_linux do
    # pianod uses avfoundation on macOS, ffmpeg on Linux
    depends_on "ffmpeg@4"
    depends_on "gcc"
    depends_on "gnutls"
    depends_on "libbsd"
  end

  fails_with gcc: "5"

  def install
    ENV["OBJCXXFLAGS"] = "-std=c++14"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system "#{bin}/pianod", "-v"
  end
end
