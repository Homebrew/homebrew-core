class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.4.5.tar.gz"
  sha256 "e006c8d0a19d148d1fa779803e19145a7d8c5f1bf1f8e9e5d2c14a5e0d860343"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "233eb89ad9d009096410b6f2c676f702e58579ac6bdcf4a08e125a36c76cb187"
    sha256 big_sur:       "d6743e6f6cbc283e1c092abf4ebfabce4fcf9fc91e8b70785d1b2d157a9e7080"
    sha256 catalina:      "c34b4fdf0dec52d264626776aa9994a8ac82e80f107816d8b5d4247853569bb4"
    sha256 mojave:        "477d6e5b7df4fefcdc35ccabb87bb724b4a8c7e591bbaa9c93f24562cdadcc64"
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
