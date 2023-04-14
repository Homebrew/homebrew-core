class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/0.99.8.tar.gz"
  sha256 "7209a875851e03ce89db3e2150ed3c1fabec5d39c0adfd74e2f37b7b2d180f48"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "ab81f9d26e43de8d3185d4e7cf0eeabaaa1387143cbd071684cc8793d694beae"
    sha256 arm64_monterey: "a3a262de074efc5ec8a984edb0bccfae18c78e79e26478a06bdc23c3313ee460"
    sha256 arm64_big_sur:  "56c3effaad1193240d2777520a04186a621d7c061fb163291b093c15b2278ff6"
    sha256 ventura:        "b8db1ffe19c3d099ffaac2c3a5401c8e0da5a5c700d85977d91e47eabed0ac34"
    sha256 monterey:       "c4d93d6b93386fcfb73e84ad3076073165e5039ab49fa6e8cba04a9dee4e27bf"
    sha256 big_sur:        "af2483fbc456dbf8ec6db9f97ce2e9991014260ff908441b47a5587fc077a2a4"
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
