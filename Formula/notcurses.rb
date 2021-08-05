class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v2.3.13.tar.gz"
  sha256 "c5eb822ea5b98028acd4a8dd21b155f893d928e4a30a8309eea0c406403af4e8"

  license "Apache-2.0"

  bottle do
    sha256 arm64_big_sur: "9abe0a85c0d90276b6e9f646d2566ad84a9266c0bb4d4c6260973a6a99e45c57"
    sha256 big_sur:       "0a847ac9d89b4b5920ede3d1b564d56f57961e315e3389673c646f12bd3b11af"
    sha256 catalina:      "371bfe4517d062ff1c3746d57ad2dce3766ce4407474cdc24987935200c28261"
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
    # without the TERM definition, Notcurses is like a small child, lost in a
    # horrible mall. of course, if the tests are run in some non-xterm
    # environment, this choice might prove unfortunate.
    # you have no chance to survive. make your time.
    ENV["TERM"] = "xterm"
    assert_match "notcurses", shell_output("#{bin}/notcurses-info")
  end
end
