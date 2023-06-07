class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/3.0.1.tar.gz"
  sha256 "94fe7e2dba60137bbfee25c037850ac064744cd8c050cc76360580b2b6790632"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "a8aa3a82b5572e3b9d3c3659830490a0bcd00466de0e49e4435ce59a2d9fbc6d"
    sha256 arm64_monterey: "19ea8ed50c0c61343331002f293a0b986c1e255dd9a03e3a5823431f09f448ab"
    sha256 arm64_big_sur:  "8fedb0163dfc9e23959d0524ca7ae28da51707f9bf4216336c8e1576479c145d"
    sha256 ventura:        "7ea320352866f4aad72798c13be048d4e2b2fcfb91abadd5ada18871e431d1c5"
    sha256 monterey:       "e54c24ca1f95ebb6cf7e832158ea9fab5923c55b33f03320df3148f22278dc95"
    sha256 big_sur:        "43ad3031090351c969f0cdb939a12ac79ac9124df213812a80b6e9fadb8e093d"
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
