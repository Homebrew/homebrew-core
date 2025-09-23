class Notcurses < Formula
  desc "Blingful character graphics/TUI library"
  homepage "https://nick-black.com/dankwiki/index.php/Notcurses"
  url "https://github.com/dankamongmen/notcurses/archive/refs/tags/v3.0.16.tar.gz"
  sha256 "e893c507eab2183b6c598a8071f2a695efa9e4de4b7f7819a457d4b579bacf05"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "6dc2beca4ea7fffcfb4dcc6b40272b4d13483ddf7abcb6ba116426a1f81a4866"
    sha256 arm64_sequoia: "7158c3e327b83e3e6158ce8888e9ce262031b5568d85fef9d42f319204da5100"
    sha256 arm64_sonoma:  "d4dd41aacd4918ba1ac4f2ea244890f197401dbc20ee46dc496664400fddb19c"
    sha256 arm64_ventura: "796aa7264d504e342713295a4b7928294d135991fbf78f3080f25ee29db59c36"
    sha256 sonoma:        "b3a829f7abe1a6be02dacd945af1695612ea94875a852e96fd7959f03d8754c1"
    sha256 ventura:       "7f3b611a052bd11205782096c416458dbda366707b9ddfc8c430e9b76bbd5899"
    sha256 arm64_linux:   "519f43f891792abdaa467df59829657169bbde6ea32825a8a6b9d122a35d95dc"
    sha256 x86_64_linux:  "00befcfe4e0d851f409847e4be62a6e4bcd739e17b83672a76cf8c9bae30906c"
  end

  depends_on "cmake" => :build
  depends_on "doctest" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "ffmpeg"
  depends_on "libdeflate"
  depends_on "libunistring"
  depends_on "ncurses"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # current homebrew CI runs with TERM=dumb. given that Notcurses explicitly
    # does not support dumb terminals (i.e. those lacking the "cup" terminfo
    # capability), we expect a failure here. all output will go to stderr.
    assert_empty shell_output(bin/"notcurses-info", 1)
  end
end
