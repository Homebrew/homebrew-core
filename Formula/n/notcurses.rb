class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "e5cc02aea82814b843cdf34dedd716e6e1e9ca440cf0f899853ca95e241bd734"
  license "Apache-2.0"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "268184d4b2841c3ca7a628f46f6f3416c3b157d9a6e147919fee79d88cd3d8e4"
    sha256 arm64_ventura:  "7d74c52ec6cb707835dc2f8a8347a8f86c19734780ed1d0075498ea3e9df1e36"
    sha256 arm64_monterey: "8761f825116a80d267288ee0872b69737fc47091bae9fe8a6243890621b4fa5a"
    sha256 sonoma:         "ba482b4d958ff4a7b37ed1b253f3012f518c9a3ea490d808f2d7ad63a6c95e1b"
    sha256 ventura:        "d3f64dc8a97d7a121d9569286612701aec7d69a17c14ec935ad61817456ba7b1"
    sha256 monterey:       "85552f9371f2872315506771205d3dd07179113e05d9bd78dc8281eb1a052085"
    sha256 x86_64_linux:   "16226399f732430e271d3567bf55de6f4b346e324897d5d5f10753e2f1fad377"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  fails_with gcc: "5"

  # Fix build with FFmpeg 7.0.
  # Remove when included in a release.
  # https://github.com/dankamongmen/notcurses/issues/2688
  patch do
    url "https://github.com/dankamongmen/notcurses/commit/d3d7a90495056c87ded7e7cc5e95e69d6d163a9e.patch?full_index=1"
    sha256 "f396550e93eaec13f8ff21e01bf89740f59a8d19e9c39f559d64f06b932e1c86"
  end
  patch do
    url "https://github.com/dankamongmen/notcurses/commit/cb1244d3d41ffbeccc059125dd98f18c94a1e59f.patch?full_index=1"
    sha256 "422dbd82f50ee545cc0843e07c5a89e3ae9e8d3c5f3063911831927809865842"
  end
  patch do
    url "https://github.com/dankamongmen/notcurses/commit/9d4c9e00836df4edd6db09e82e3042816b435c3c.patch?full_index=1"
    sha256 "e977892c93b54dd86a95db7af14fcefcc4f7bd023fa3c7a8cf4d9eeefbba9883"
  end
  patch do
    url "https://github.com/dankamongmen/notcurses/commit/bed402adf98ae51efeb9ac3a71f88facfbf7290c.patch?full_index=1"
    sha256 "a6969365db2b7e59085fa382b016a0dac1a8c6a493909c8e3ac17e7f7b4dccb3"
  end
  patch do
    url "https://github.com/dankamongmen/notcurses/commit/441d66a063c7fc86436ed7ff73984050434c9142.patch?full_index=1"
    sha256 "aee69211bf5280bb773360a0f206e79f825ae86dbb7e05117d69acfa12917c13"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output("#{bin}/notcurses-info", 1)
  end
end
