class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.4.tar.gz"
  sha256 "25bb95b8705d8c79bde447e7c7019372eea7eaed9d0268510278e7fcdb1378a5"
  license all_of: [
    "BSD-3-Clause",
    "GPL-2.0-or-later", # src/plugins/supereqdsp/supereq/
    "LGPL-2.1-or-later", # src/plugins/pulseout/pulse_blocking_stream.c (Linux)
    "BSL-1.0", # src/3rdparty/include/utf8/
    "MIT", # src/3rdparty/include/{nlohmann,sqlean}/, src/3rdparty/include/websocketpp/utf8_validator.hpp
    "Zlib", # src/3rdparty/include/websocketpp/base64/base64.hpp
    "bcrypt-Solar-Designer", # src/3rdparty/{include,src}/md5.*
    "blessing", # src/3rdparty/{include,src}/sqlite/sqlite3*
  ]
  head "https://github.com/clangen/musikcube.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "d04141a58c24c85ffa338bee5422ce3962667bb68549f9ecac5def08532034c6"
    sha256 cellar: :any,                 arm64_sonoma:   "00e57d9c9357ab897d8323351cf88191b9cad6287137d0ae825f75bf0372e353"
    sha256 cellar: :any,                 arm64_ventura:  "e6ca7dd553d722a0770980c8a28fca32bfff4493a14e09e09e9767ec223f727b"
    sha256 cellar: :any,                 arm64_monterey: "20dea11a6b5a33fca28fa4bd4f78b3c81a464d14e441c95d402cd3c751b5fbf7"
    sha256 cellar: :any,                 sonoma:         "0d6f7ff35bdd8033ba4b90d3b027b8d64cb1429dfcee43b084bfa1ae7804d3f3"
    sha256 cellar: :any,                 ventura:        "4dd0a8e8881f3e1ca1cb537b13c5b0492af99838e9c2d14b2c60b4c2820fad4f"
    sha256 cellar: :any,                 monterey:       "b57720e0c6a394c9e52406ed7bbc942ec61b01e9d1705b2caecf571fcbd478a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a1615f9ef8bf8645ecf31d0679e1a96a526e881beddbc1e25d0fe8089f6385eb"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build

  depends_on "ffmpeg"
  depends_on "game-music-emu"
  depends_on "lame"
  depends_on "libev"
  depends_on "libmicrohttpd"
  depends_on "libopenmpt"
  depends_on "ncurses"
  depends_on "openssl@3"
  depends_on "portaudio"
  depends_on "taglib"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gnutls"
    depends_on "mpg123"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
    depends_on "systemd"
  end

  def install
    # Pretend to be Nix to dynamically link ncurses on macOS.
    ENV["NIX_CC"] = ENV.cc

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    ENV["MUSIKCUBED_LOCKFILE_OVERRIDE"] = lockfile = testpath/"musikcubed.lock"
    system bin/"musikcubed", "--start"
    sleep 10
    assert_path_exists lockfile
    tries = 0
    begin
      system bin/"musikcubed", "--stop"
    rescue BuildError
      # Linux CI seems to take some more time to stop
      retry if OS.linux? && (tries += 1) < 3
      raise
    end
  end
end
