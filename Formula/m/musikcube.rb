class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.2.tar.gz"
  sha256 "65f82db36d635bdbfd99f67d1d68c9e1aedf8e38efa627f303cf7971c306d063"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "973c9e44a3834eff19673fe4aa85a46edeccd856f8d38436830537f2cfd6adbe"
    sha256 arm64_ventura:  "f66fe00d4f779b42531b29ff3d49ee1dca54d9ebb8e69ce15bcee6f1b538c834"
    sha256 arm64_monterey: "cbc1e67a73376ede3d261bbd7df91ae49511c9b0b357218a3707074ff34bc522"
    sha256 sonoma:         "552d3abc223e7f180f4756d698b538381bbe34e16458fddf24c742187689faf0"
    sha256 ventura:        "4f8f9a178681fbf0e68846381f039c88a2d5c058bd48aba2b6ffcb48d4e6aabd"
    sha256 monterey:       "ba6f7193efdb416a51c57c74322742716fe040cb8371f43bee1b1a492fe7e80c"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg@6"
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
