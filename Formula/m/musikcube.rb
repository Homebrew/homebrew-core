class Musikcube < Formula
  desc "Terminal-based audio engine, library, player and server"
  homepage "https://musikcube.com"
  url "https://github.com/clangen/musikcube/archive/refs/tags/3.0.5.tar.gz"
  sha256 "708292a583bb5072a8dbb14e408c2a1f61de9b8c9786d4e53b3e69bef5dad8c5"
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
    sha256 cellar: :any,                 arm64_tahoe:   "e6fd6937db9dc61aebd99b2c780cfc3ff3695bf84fd18238e9c7ecc5a25ba593"
    sha256 cellar: :any,                 arm64_sequoia: "41dfc5305a87586f4f2d136f677bc198c79db7d30df81809d58d7b1fcb7eb38d"
    sha256 cellar: :any,                 arm64_sonoma:  "bacb6f49ec2828235426ded597644a0bcca26ee5d15b16f310edf263611de1ca"
    sha256 cellar: :any,                 sonoma:        "b939da5923b96d4255861e2dc0f4e94782c611f2c1b980f484ea38e6ae4edf73"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42589a10177bdc704cababe52c87c3f2ef8aa2bd16ea06fb494c7316be1f7458"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bf96f0464fe141e3dcb43ef964142ecdec61b3b8906b7f3e0962c8020f27306"
  end

  depends_on "asio" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

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
