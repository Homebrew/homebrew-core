class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.7.tar.gz"
  sha256 "c79d960acc5233b8c61f45e4abad8037015258d697685ed106483692402b657f"
  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "0b98b6de24bbb7c4e36507b426948ffc57d07945bdddaf6772a0cf528068bcc5"
    sha256 big_sur:       "a168682b2465c70e579a146d919dc96f6dbe59991a6a00f45655fa1b565c5252"
    sha256 catalina:      "2db3428332de5796b7911dc9ed5a7ac92ef7ac8779a8be80bb8e2658723aa556"
    sha256 mojave:        "f134e6407c98ac8da525a4faddaa153060a5e5f7c3ab022b61ec40c551c0b300"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkg-config" => :build
  depends_on "ffmpeg"
  depends_on "libunistring"
  depends_on "ncurses"
  uses_from_macos "zlib"

  fails_with gcc: "5"

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
