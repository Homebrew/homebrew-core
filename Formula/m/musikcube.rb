class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.4.tar.gz"
  sha256 "25bb95b8705d8c79bde447e7c7019372eea7eaed9d0268510278e7fcdb1378a5"
  license "BSD-3-Clause"
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "59aa9a51bc017b88fb4e5b6841452f5933e7a84e1769db122445b370ef1d8047"
    sha256 arm64_ventura:  "a8b4b4f99b07b95acf97cb0db02aefc64bc9e1e35d2ea34223c2a9062a167a29"
    sha256 arm64_monterey: "a90d7dfd1ade9c1168cff35fa52de9018b89261055da93cb38d5ce59b85f20e9"
    sha256 sonoma:         "a1953c59d50ab92536a60e824a97558edb1f4fafce514df81db712f0d7519de4"
    sha256 ventura:        "b2fd6204a72b9736872184db685e89c326639755da0ffe2d526bb041f8557e71"
    sha256 monterey:       "e2ad36a2565ba7e15e751e5acd0bf92375dde852c83c7869b163dd66713012f6"
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

  on_macos do
    depends_on "mpg123"
    depends_on "portaudio"
  end

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
