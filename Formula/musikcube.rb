class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/3.0.0.tar.gz"
  sha256 "b857980c214f86f17cc288eda4562b51683cd42a843a4a4d8d8e60169cf87345"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "9ae9782c56382350a4e1cff4cb469f65750b8c5bf0dc9472543de712fe5e2bea"
    sha256 arm64_monterey: "aa74ba7f2506d2805d9c93a59d99295dc5c76a54c309b5f71abe1391837aac0d"
    sha256 arm64_big_sur:  "5920424571236fc99bd66fea9efcde1f6a88dd254486e89c4757b41158aa6a2a"
    sha256 ventura:        "75383aa262c534e6362f261fd1b8683aa23a9e804aa6f083948f71675dce1941"
    sha256 monterey:       "86bf2e4ac36925adc56024f4e6a4000a6463398edc2fe54b6d08f1bb304d905f"
    sha256 big_sur:        "ee53aa9f42f7e90d77684e5814275087cb6b08289bdfdda18e7ee69d3780ecfd"
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
  depends_on "openssl@1.1"
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
