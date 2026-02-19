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
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "f079cd99390fa8cfde2954b29c85ec1dbb7463fcda7379d7d65a9728dd70135c"
    sha256 cellar: :any,                 arm64_sequoia: "61f16a85ce157e22e75af7904af8dca3b3dd24a0ead22ee487303a8a231fe17e"
    sha256 cellar: :any,                 arm64_sonoma:  "eaf80bc92fb9ff264094e71104f563709c8f5aa8c6cf6719c2b4099ff47c2559"
    sha256 cellar: :any,                 sonoma:        "902d978d1bf5ad4507cb22e6bdbed88d4ce91a40d9978148064ff2cb31afbb4b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0aca547fb4d9aba99e8a2c85cd7c2c512699c40ab6ff058e5df2c7bf3de62e1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6ce68dae9715ffd29bf3fbf6884ff2797f20fee61bd972dfb4bf63763bba390e"
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

  on_macos do
    depends_on "gnutls"
    depends_on "mpg123"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "pulseaudio"
    depends_on "systemd"
    depends_on "zlib-ng-compat"
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
