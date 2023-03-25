class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/0.99.7.tar.gz"
  sha256 "60796ff96e2b760350181609d9b838e96efdb1231a421407db55eba157fea4d5"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "a132d430e8e2925c248b2b5c213a7c3091675f08b1967079632c4977072c2a1b"
    sha256 arm64_monterey: "78d9275f04cd807636e4be2acc0dcb6535d17d86007ad62689ae66a4852ab06e"
    sha256 arm64_big_sur:  "db45728f40e566719aee003e3b4860f8b5a3aba83cd0a580b93a4843e6e5f627"
    sha256 ventura:        "9ddea21473697c3daa6c439b0bfd5c3fcb9524c6d6ecb94e65c2f7725456df8f"
    sha256 monterey:       "c625c36435cbcaa3c3b642ca80a8d6731a68417bde9fac1f7c5c52a1186b146f"
    sha256 big_sur:        "e086be62cb22cc12f91fcb48605022fe90dc64a9712f57f51a881ab374a0ac6b"
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
