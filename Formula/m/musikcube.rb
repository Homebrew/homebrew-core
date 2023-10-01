class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/3.0.2.tar.gz"
  sha256 "65f82db36d635bdbfd99f67d1d68c9e1aedf8e38efa627f303cf7971c306d063"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "512fb81f7ba32be15e99b9cc7f1b5f5641ece2280a57fb9959b16c7a5a7d8d69"
    sha256 arm64_monterey: "fee7d42e15666be622d7ea0c82cfba4c016018084e65b33c51fb11275e1ed068"
    sha256 arm64_big_sur:  "c0f55bc4c17cd63c6f60a38c5dc23e575af1fc6e351d374463dbf6002cfd11aa"
    sha256 ventura:        "e234af5ad4c039335c5318b3b3a44d63e80a51bbad81ad8dc45b8211b24810fa"
    sha256 monterey:       "4921d57427b29a1d1d51f06a8a39770223b1a4d08308c002faca0b2126b7db9f"
    sha256 big_sur:        "e5adeaf772f02f6a98ef4794f77c28c46eff02ff5c5a1e48d0cd21eb3b4e151f"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "gnutls"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libogg"
  depends_on "libopenmpt"
  depends_on "libvorbis"
  depends_on :macos
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "taglib"
  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"musikcubed", "--start"
    system "sleep", "5"
    assert_path_exists "/tmp/musikcubed.lock"
    system "sleep", "5"
    system bin/"musikcubed", "--stop"
  end
end
