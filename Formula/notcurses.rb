class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/v3.0.2.tar.gz"
  sha256 "051ee9557f5842ead9f633495c9e28066a1c72ef5a15cbb72218a167df6ab1cc"
  license "Apache-2.0"

  bottle do
    sha256 arm64_monterey: "0d7cc8c2882b0db4eba6005ae4719503a366f33576794d17eed3305cc55b52de"
    sha256 arm64_big_sur:  "9614fe468125c50f135d45bc9446f8e8326bda72aace404afdb90f701460aab7"
    sha256 monterey:       "95ef49f755429c729a153f24b205d57e19679cdb468a530178e57d4489f01452"
    sha256 big_sur:        "ec5f0f528e8dfdc893356c4acd0af87eb6eb0dad95a1618e3d855179fffd895c"
    sha256 catalina:       "b45268b7189c40bf426b82515ccd9e0516ccb850cddefe191106741505188359"
    sha256 x86_64_linux:   "41fede1f89a0b5900328faed45ed494725876e5e314cf8f4574986df407947b1"
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
