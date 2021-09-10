class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.0.tar.gz"
  sha256 "9bc35bfaadfd51d45e3de6d3b5d6d484a3042773a10904cb1bf4c7562d834d77"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "2214f51b0442322823fe21edc073aed06e993d95277a628fae2a1575f0a5d9a4"
    sha256 big_sur:       "a2b0ccf2c2cf22964ec0678aa8dbc04d3ee326c8314fcb82408c6154fa6bd4e9"
    sha256 catalina:      "b35722ef54ab47ac89a2a57bbcc8d9d28b817a6c751e360abf8a291614f712d0"
    sha256 mojave:        "92f08c1c6e076a8b8cee89a326c2ecf8e31d47bc0d40cbfced7e802629959998"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  depends_on "readline"
  uses_from_macos "zlib"

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
